import 'package:collector_app/blocs/events/abstract_event.dart';
import 'package:collector_app/log/logger.dart';
import 'package:collector_app/providers/configs/injection_config.dart';
import 'package:collector_app/providers/services/transaction_service.dart';
import 'package:collector_app/utils/common_function.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

part 'states/payable_amount_state.dart';
part 'events/payable_amount_event.dart';

class PayableAmountBloc extends Bloc<PayableAmountEvent, PayableAmountState> {
  PayableAmountBloc({TransactionService? transactionService})
      : super(PayableAmountState()) {
    _transactionService = transactionService ?? getIt.get<TransactionService>();
  }

  late final TransactionService _transactionService;

  @override
  Stream<PayableAmountState> mapEventToState(PayableAmountEvent event) async* {
    if (event is PayableAmountGet) {
      try {
        yield state.copyWith(status: FormzStatus.submissionInProgress);
        var data = await futureAppDuration(
          _transactionService.getPayableAmount(),
        );

        yield data.copyWith(
          status: FormzStatus.submissionSuccess,
        );
      } catch (e) {
        AppLog.error(e);
        yield state.copyWith(status: FormzStatus.submissionFailure);
      }
    } else if (event is PayableMonthChanged) {
      try {
        var index = state.listPayableAmount.indexOf(event.model);
        yield state.copyWith(chosenIndex: index);
      } catch (e) {
        AppLog.error(e);
        yield state.copyWith(status: FormzStatus.submissionFailure);
      }
    }
  }
}
