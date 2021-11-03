import 'package:collector_app/blocs/events/abstract_event.dart';
import 'package:collector_app/blocs/models/feedback_admin_model.dart';
import 'package:collector_app/constants/constants.dart';
import 'package:collector_app/log/logger.dart';
import 'package:collector_app/providers/configs/injection_config.dart';
import 'package:collector_app/providers/services/transaction_service.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

part 'states/feedback_admin_state.dart';
part 'events/feedback_admin_event.dart';

class FeedbackAdminBloc extends Bloc<FeedbackAdminEvent, FeedbackAdminState> {
  late TransactionService _transactionService;
  FeedbackAdminBloc({
    required String requestId,
    required int complaintType,
    TransactionService? transactionService,
  }) : super(
          FeedbackAdminState(
            requestId: requestId,
            complaintType: complaintType,
          ),
        ) {
    _transactionService = transactionService ?? getIt.get<TransactionService>();
  }

  @override
  Stream<FeedbackAdminState> mapEventToState(FeedbackAdminEvent event) async* {
    if (event is FeedbackAdminChanged) {
      try {
        var feedback = FeedbackAdmin.dirty(event.feedback);
        yield state.copyWith(
          feedbackAdmin: feedback,
          status: Formz.validate([feedback]),
        );
      } catch (e) {
        AppLog.error(e);
      }
    } else if (event is FeedbackAdminSubmmited) {
      try {
        yield state.copyWith(
          status: FormzStatus.submissionInProgress,
        );
        var feedback = FeedbackAdmin.dirty(state.feedbackAdmin.value);
        yield state.copyWith(
          feedbackAdmin: feedback,
          status: Formz.validate([feedback]),
        );

        if (state.status.isValid) {
          bool result = await _transactionService.complainTransaction(
            state.requestId,
            state.feedbackAdmin.value,
            state.complaintType,
          );

          if (result) {
            yield state.copyWith(
              status: FormzStatus.submissionSuccess,
            );
          } else {
            throw Exception('feedbackAdmin is false');
          }
        } else {
          throw Exception('Feedback admin is not valid');
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
