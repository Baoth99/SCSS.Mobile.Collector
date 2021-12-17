import 'package:collector_app/blocs/events/abstract_event.dart';
import 'package:collector_app/blocs/models/cancel_reason_model.dart';
import 'package:collector_app/constants/constants.dart';
import 'package:collector_app/log/logger.dart';
import 'package:collector_app/providers/configs/injection_config.dart';
import 'package:collector_app/providers/services/collecting_request_service.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

part 'states/cancel_request_state.dart';
part 'events/cancel_request_event.dart';

class CancelRequestBloc extends Bloc<CancelRequestEvent, CancelRequestState> {
  late CollectingRequestService _collectingRequestService;
  CancelRequestBloc({
    required String requestId,
    CollectingRequestService? collectingRequestService,
  }) : super(
          CancelRequestState(
            requestId: requestId,
            cancelReasons: [],
          ),
        ) {
    _collectingRequestService =
        collectingRequestService ?? getIt.get<CollectingRequestService>();
  }

  @override
  Stream<CancelRequestState> mapEventToState(CancelRequestEvent event) async* {
    if (event is CancelRequestIntial) {
      yield state.copyWith(
        dataIntial: CancelRequestDataIntial.procerss,
      );

      var data = await _collectingRequestService.getCancelReasons();

      yield state.copyWith(
        dataIntial: CancelRequestDataIntial.done,
        cancelReasons: data,
      );
    }
    if (event is CancelReasonChanged) {
      try {
        var cancelReason = CancelReason.dirty(event.cancelReason);
        yield state.copyWith(
          cancelReason: cancelReason,
          status: Formz.validate([cancelReason]),
        );
      } catch (e) {
        AppLog.error(e);
      }
    } else if (event is CancelRequestSubmmited) {
      try {
        yield state.copyWith(
          status: FormzStatus.submissionInProgress,
        );
        var cancelReason = CancelReason.dirty(state.cancelReason.value);
        yield state.copyWith(
          cancelReason: cancelReason,
          status: Formz.validate([cancelReason]),
        );

        if (state.status.isValid) {
          bool result = await _collectingRequestService.cancelRequest(
            state.requestId,
            state.cancelReason.value,
          );

          if (result) {
            yield state.copyWith(
              status: FormzStatus.submissionSuccess,
            );
          } else {
            throw Exception('cancelReason is false');
          }
        } else {
          throw Exception('cancelReason is not valid');
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
