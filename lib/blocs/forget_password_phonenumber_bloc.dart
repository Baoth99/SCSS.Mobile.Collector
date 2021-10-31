import 'package:collector_app/blocs/events/abstract_event.dart';
import 'package:collector_app/blocs/models/phone_number_model.dart';
import 'package:collector_app/log/logger.dart';
import 'package:collector_app/providers/configs/injection_config.dart';
import 'package:collector_app/providers/services/identity_server_service.dart';
import 'package:collector_app/utils/common_function.dart';
import 'package:collector_app/utils/common_utils.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

part 'states/forget_password_phonenumber_state.dart';
part 'events/forget_password_phonenumber_event.dart';

class ForgetPasswordPhoneNumberBloc extends Bloc<ForgetPasswordPhoneNumberEvent,
    ForgetPasswordPhoneNumberState> {
  late IdentityServerService _identityServerService;
  ForgetPasswordPhoneNumberBloc({
    IdentityServerService? identityServerService,
  }) : super(
          const ForgetPasswordPhoneNumberState(),
        ) {
    _identityServerService =
        identityServerService ?? getIt.get<IdentityServerService>();
  }

  @override
  Stream<ForgetPasswordPhoneNumberState> mapEventToState(
      ForgetPasswordPhoneNumberEvent event) async* {
    if (event is ForgetPasswordPhoneNumberChanged) {
      try {
        var phoneNumber = PhoneNumber.dirty(event.phoneNumber);
        yield state.copyWith(
          phoneNumber: phoneNumber,
          status: Formz.validate([phoneNumber]),
        );
      } catch (e) {
        AppLog.error(e);
      }
    } else if (event is ForgetPasswordPhoneNumberSubmmited) {
      try {
        var phoneNumber = PhoneNumber.dirty(state.phoneNumber.value);
        yield state.copyWith(
          phoneNumber: phoneNumber,
          status: Formz.validate([phoneNumber]),
        );

        if (state.status.isValid) {
          yield state.copyWith(
            status: FormzStatus.submissionInProgress,
          );

          var result = await futureAppDuration(
            _identityServerService.restorePassSendingOTP(phoneNumber.value),
          );

          if (result) {
            var strphoneNumber = CommonUtils.addZeroBeforePhoneNumber(
              state.phoneNumber.value,
            );

            yield state.copyWith(
              phoneNumber: PhoneNumber.dirty(strphoneNumber),
            );
          }

          yield state.copyWith(
            status: FormzStatus.submissionSuccess,
            isExist: result,
          );
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
