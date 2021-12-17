import 'package:collector_app/blocs/events/abstract_event.dart';
import 'package:collector_app/constants/constants.dart';
import 'package:collector_app/log/logger.dart';
import 'package:collector_app/providers/configs/injection_config.dart';
import 'package:collector_app/providers/services/transaction_service.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

part 'states/feedback_dealer_transaction_state.dart';
part 'events/feedback_dealer_transaction_event.dart';

class FeedbackDealerTransactionBloc extends Bloc<FeedbackDealerTransactionEvent,
    FeedbackDealerTransactionState> {
  late final TransactionService _transactionService;
  FeedbackDealerTransactionBloc({
    required String transactionId,
    required double rates,
    TransactionService? transactionService,
  }) : super(
          FeedbackDealerTransactionState(
            transactionId: transactionId,
            rate: rates,
          ),
        ) {
    _transactionService = transactionService ?? getIt.get<TransactionService>();
  }

  @override
  Stream<FeedbackDealerTransactionState> mapEventToState(
      FeedbackDealerTransactionEvent event) async* {
    if (event is FeedbackDealerReviewChanged) {
      try {
        yield state.copyWith(
          review: event.review,
        );
      } catch (e) {
        AppLog.error(e);
      }
    } else if (event is FeedbackDealerRateChanged) {
      try {
        yield state.copyWith(
          rate: event.rate,
        );
      } catch (e) {
        AppLog.error(e);
      }
    } else if (event is FeedbackDealerTransactionSubmmited) {
      try {
        yield state.copyWith(
          status: FormzStatus.submissionInProgress,
        );
        bool result = await _transactionService.feedbackDealerTransaction(
          state.transactionId,
          state.rate,
          state.review,
        );

        if (result) {
          yield state.copyWith(
            status: FormzStatus.submissionSuccess,
          );
        } else {
          throw Exception('feedbackAdmin is false');
        }
      } catch (e) {
        AppLog.error(e);
        yield state.copyWith(
          status: FormzStatus.submissionFailure,
        );
      }
    }
  }
}
