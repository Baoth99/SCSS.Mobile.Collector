import 'package:collector_app/blocs/events/abstract_event.dart';
import 'package:collector_app/constants/constants.dart';
import 'package:collector_app/log/logger.dart';
import 'package:collector_app/providers/configs/injection_config.dart';
import 'package:collector_app/providers/services/transaction_service.dart';
import 'package:collector_app/utils/common_function.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

part 'events/seller_transaction_detail_event.dart';
part 'states/seller_transaction_detail_state.dart';

class SellerTransactionDetailBloc
    extends Bloc<SellerTransactionDetailEvent, SellerTransactionDetailState> {
  SellerTransactionDetailBloc({
    required String id,
    TransactionService? transactionService,
  }) : super(SellerTransactionDetailState(id: id)) {
    _transactionService = transactionService ?? getIt.get<TransactionService>();
  }

  late final TransactionService _transactionService;

  @override
  Stream<SellerTransactionDetailState> mapEventToState(
      SellerTransactionDetailEvent event) async* {
    if (event is SellerTransactionDetailInitial) {
      try {
        yield state.copyWith(
          stateStatus: FormzStatus.submissionInProgress,
        );

        var data = await futureAppDuration(
          _transactionService.getSellerTransactionDetail(state.id),
        );

        if (data != null) {
          yield state.copyWith(
            billTotal: data.billTotal,
            collectingRequestCode: data.collectingRequestCode,
            itemTotal: data.itemTotal,
            status: data.status,
            transaction: data.transaction,
            doneActivityTime: data.doneActivityTime,
            serviceFee: data.serviceFee,
            stateStatus: FormzStatus.submissionSuccess,
            sellerName: data.sellerName,
            complaint: data.complaint,
          );
        } else {
          throw Exception();
        }
      } catch (e) {
        AppLog.error(e);
        yield state.copyWith(
          stateStatus: FormzStatus.submissionFailure,
        );
      }
    }
  }
}
