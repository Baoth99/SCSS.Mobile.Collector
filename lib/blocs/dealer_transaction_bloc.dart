import 'package:collector_app/blocs/events/abstract_event.dart';
import 'package:collector_app/providers/configs/injection_config.dart';
import 'package:collector_app/providers/services/transaction_service.dart';
import 'package:collector_app/utils/common_function.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
part 'events/dealer_transaction_event.dart';
part 'states/dealer_transaction_state.dart';

class DealerTransactionBloc
    extends Bloc<DealerTransactionEvent, DealerTransactionState> {
  DealerTransactionBloc({
    TransactionService? transactionService,
  }) : super(
          DealerTransactionState(),
        ) {
    _transactionService = transactionService ?? getIt.get<TransactionService>();
  }
  late final TransactionService _transactionService;
  final initialAbstractPage = 2;
  final sizeList = 10;
  @override
  Stream<DealerTransactionState> mapEventToState(
      DealerTransactionEvent event) async* {
    if (event is DealerTransactionInitial) {
      int pageSize = initialAbstractPage * sizeList;

      try {
        yield state.copyWith(
          status: DealerTransactionStatus.progress,
        );

        var listTransaction = await getDealerTransaction(1, pageSize);

        yield state.copyWith(
          status: DealerTransactionStatus.completed,
          listDealerTransaction: listTransaction,
          page: listTransaction.isNotEmpty ? initialAbstractPage : 0,
        );
      } catch (e) {
        yield state.copyWith(
          status: DealerTransactionStatus.error,
        );
      }
    } else if (event is DealerTransactionRefresh) {
      int pageSize = initialAbstractPage * sizeList;

      try {
        yield state.copyWith(
          refreshStatus: RefreshStatus.refreshing,
        );
        var listTransaction = await getDealerTransaction(1, pageSize);

        yield state.copyWith(
          refreshStatus: RefreshStatus.completed,
          listDealerTransaction: listTransaction,
          page: listTransaction.isNotEmpty ? initialAbstractPage : 0,
        );
      } catch (e) {
        yield state.copyWith(
          refreshStatus: RefreshStatus.failed,
        );
      }
    } else if (event is DealerTransactionLoading) {
      try {
        yield state.copyWith(
          loadStatus: LoadStatus.loading,
        );
        var listTransaction =
            await getDealerTransaction(state.page + 1, sizeList);
        yield state.copyWith(
          loadStatus: LoadStatus.idle,
          listDealerTransaction: state.listDealerTransaction
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

  Future<List<DealerTransaction>> getDealerTransaction(
      int page, int size) async {
    return await futureAppDuration<List<DealerTransaction>>(
      _transactionService.getDealerTransaction(page, size),
    );
  }
}
