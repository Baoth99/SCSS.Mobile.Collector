import 'package:collector_app/blocs/events/abstract_event.dart';
import 'package:collector_app/constants/constants.dart';
import 'package:collector_app/log/logger.dart';
import 'package:collector_app/providers/configs/injection_config.dart';
import 'package:collector_app/providers/services/transaction_service.dart';
import 'package:collector_app/utils/common_function.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

part 'events/dealer_transaction_detail_event.dart';
part 'states/dealer_transaction_detail_state.dart';

class DealerTransactionDetailBloc
    extends Bloc<DealerTransactionDetailEvent, DealerTransactionDetailState> {
  DealerTransactionDetailBloc({
    required String id,
    TransactionService? transactionService,
  }) : super(DealerTransactionDetailState(id: id)) {
    _transactionService = transactionService ?? getIt.get<TransactionService>();
  }

  late final TransactionService _transactionService;

  @override
  Stream<DealerTransactionDetailState> mapEventToState(
      DealerTransactionDetailEvent event) async* {
    if (event is DealerTransactionDetailInitial) {
      try {
        yield state.copyWith(
          stateStatus: FormzStatus.submissionInProgress,
        );

        var data = await futureAppDuration(
          _transactionService.getDealerTransactionDetail(state.id),
        );

        if (data != null) {
          yield data.copyWith(
            stateStatus: FormzStatus.submissionSuccess,
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
