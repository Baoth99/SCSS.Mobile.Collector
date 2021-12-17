import 'package:collector_app/blocs/events/abstract_event.dart';
import 'package:collector_app/providers/configs/injection_config.dart';
import 'package:collector_app/providers/services/transaction_service.dart';
import 'package:collector_app/utils/common_function.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
part 'events/seller_transaction_event.dart';
part 'states/seller_transaction_state.dart';

class SellerTransactionBloc
    extends Bloc<SellerTransactionEvent, SellerTransactionState> {
  SellerTransactionBloc({
    TransactionService? transactionService,
  }) : super(
          SellerTransactionState(),
        ) {
    _transactionService = transactionService ?? getIt.get<TransactionService>();
  }
  late final TransactionService _transactionService;
  final initialAbstractPage = 2;
  final sizeList = 10;
  @override
  Stream<SellerTransactionState> mapEventToState(
      SellerTransactionEvent event) async* {
    if (event is SellerTransactionInitial) {
      int pageSize = initialAbstractPage * sizeList;

      try {
        yield state.copyWith(
          status: SellerTransactionStatus.progress,
        );

        var listTransaction = await getSellerTransaction(1, pageSize);

        yield state.copyWith(
          status: SellerTransactionStatus.completed,
          listSellerTransaction: listTransaction,
          page: listTransaction.isNotEmpty ? initialAbstractPage : 0,
        );
      } catch (e) {
        yield state.copyWith(
          status: SellerTransactionStatus.error,
        );
      }
    } else if (event is SellerTransactionRefresh) {
      int pageSize = initialAbstractPage * sizeList;

      try {
        yield state.copyWith(
          refreshStatus: RefreshStatus.refreshing,
        );
        var listTransaction = await getSellerTransaction(1, pageSize);

        yield state.copyWith(
          refreshStatus: RefreshStatus.completed,
          listSellerTransaction: listTransaction,
          page: listTransaction.isNotEmpty ? initialAbstractPage : 0,
        );
      } catch (e) {
        yield state.copyWith(
          refreshStatus: RefreshStatus.failed,
        );
      }
    } else if (event is SellerTransactionLoading) {
      try {
        yield state.copyWith(
          loadStatus: LoadStatus.loading,
        );
        var listTransaction =
            await getSellerTransaction(state.page + 1, sizeList);
        yield state.copyWith(
          loadStatus: LoadStatus.idle,
          listSellerTransaction: state.listSellerTransaction
            ..addAll(listTransaction),
          page: listTransaction.isNotEmpty ? state.page + 1 : state.page,
        );
      } catch (e) {
        yield state.copyWith(
          loadStatus: LoadStatus.idle,
        );
      }
    }
  }

  Future<List<SellerTransaction>> getSellerTransaction(
      int page, int size) async {
    return await futureAppDuration<List<SellerTransaction>>(
      _transactionService.getSellerTransaction(page, size),
    );
  }
}
