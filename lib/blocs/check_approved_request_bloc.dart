import 'package:collector_app/constants/constants.dart';
import 'package:collector_app/log/logger.dart';
import 'package:collector_app/providers/configs/injection_config.dart';
import 'package:collector_app/providers/services/collecting_request_service.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'states/check_approved_request_state.dart';
part 'events/check_approved_request_event.dart';

class CheckApprovedRequestBloc
    extends Bloc<CheckApprovedRequestEvent, CheckApprovedRequestState> {
  CheckApprovedRequestBloc() : super(CheckApprovedRequestState());
  @override
  Stream<CheckApprovedRequestState> mapEventToState(
      CheckApprovedRequestEvent event) async* {
    if (event is CheckApprovedRealTime) {
      try {
        var currentId = state.id;
        if (currentId.isNotEmpty &&
            !state.isApprovedByYou &&
            currentId == event.id) {
          yield state.copyWith(isApprovedBySomebody: true);
        }
      } catch (e) {
        AppLog.error(e);
      }
    } else if (event is RefershCheckApproved) {
      try {
        yield CheckApprovedRequestState();
      } catch (e) {
        AppLog.error(e);
      }
    } else if (event is AddIdCheckApprove) {
      try {
        yield state.copyWith(id: event.id);
      } catch (e) {
        AppLog.error(e);
      }
    } else if (event is ApproveCheckApproved) {
      try {
        yield state.copyWith(isApprovedByYou: true);
      } catch (e) {
        AppLog.error(e);
      }
    }
  }
}
