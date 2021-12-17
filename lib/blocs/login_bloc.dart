import 'package:collector_app/blocs/events/abstract_event.dart';
import 'package:collector_app/blocs/models/login_model.dart';
import 'package:collector_app/blocs/states/password_login_model.dart';
import 'package:collector_app/constants/api_constants.dart';
import 'package:collector_app/constants/constants.dart';
import 'package:collector_app/exceptions/custom_exceptions.dart';
import 'package:collector_app/log/logger.dart';
import 'package:collector_app/providers/configs/injection_config.dart';
import 'package:collector_app/providers/services/firebase_service.dart';
import 'package:collector_app/providers/services/identity_server_service.dart';
import 'package:collector_app/utils/common_function.dart';
import 'package:collector_app/utils/common_utils.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
part 'states/login_state.dart';
part 'events/login_event.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  late IdentityServerService _identityServerService;
  late FirebaseNotification _firebaseNotification;

  LoginBloc({
    IdentityServerService? identityServerService,
    FirebaseNotification? firebaseNotification,
  }) : super(const LoginState()) {
    _identityServerService =
        identityServerService ?? getIt.get<IdentityServerService>();
    _firebaseNotification =
        firebaseNotification ?? getIt.get<FirebaseNotification>();
  }

  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    if (event is LoginPhoneNumberChanged) {
      var phoneNumber = LoginPhoneNumber.dirty(event.phoneNumber);
      yield state.copyWith(
        phoneNumber: phoneNumber,
        status: Formz.validate(
          [
            phoneNumber,
            state.password,
          ],
        ),
      );
    } else if (event is LoginPasswordChanged) {
      var password = PasswordLogin.dirty(
        password: state.password.value.copyWith(
          value: event.password,
        ),
      );

      yield state.copyWith(
        password: password,
        status: Formz.validate(
          [
            state.phoneNumber,
            password,
          ],
        ),
      );
    } else if (event is LoginButtonSubmmited) {
      var phoneNumber = LoginPhoneNumber.dirty(state.phoneNumber.value);
      var password = PasswordLogin.dirty(
        password: state.password.value.copyWith(
          value: state.password.value.value,
        ),
      );
      yield state.copyWith(
        phoneNumber: phoneNumber,
        password: password,
        status: Formz.validate(
          [
            phoneNumber,
            password,
          ],
        ),
      );

      if (state.status.isValid) {
        try {
          yield state.copyWith(
            status: FormzStatus.submissionInProgress,
          );

          // cal API
          var response = await _identityServerService.getToken(
            state.phoneNumber.value,
            state.password.value.value,
          );

          if (response.accessToken != null && response.refreshToken != null) {
            if (response.accessToken!.isNotEmpty &&
                response.refreshToken!.isNotEmpty) {
              // save to share preferences
              var accessResult = await SharedPreferenceUtils.setString(
                  APIKeyConstants.accessToken, response.accessToken!);
              var refreshResult = await SharedPreferenceUtils.setString(
                  APIKeyConstants.refreshToken, response.refreshToken!);

              if (accessResult && refreshResult) {
                // generate satus success

                // update deviceID
                _firebaseNotification.updateToken();
                yield state.copyWith(
                  status: FormzStatus.submissionSuccess,
                  loginStatus: LoginStatus.success,
                );
              } else {
                throw Exception(CommonApiConstants.engErrorSystem);
              }
            } else if (response.accessToken!.isEmpty &&
                response.refreshToken!.isEmpty) {
              yield state.copyWith(
                phoneNumber: const LoginPhoneNumber.pure(),
                password: const PasswordLogin.pure(),
                status: FormzStatus.invalid,
              );
            } else {
              throw Exception(CommonApiConstants.engErrorSystem);
            }
          } else {
            throw Exception(CommonApiConstants.engErrorSystem);
          }
        } on NotApprovedException catch (e) {
          AppLog.info(e);
          yield state.copyWith(
            status: FormzStatus.submissionSuccess,
            loginStatus: LoginStatus.notApproved,
          );
        } on Exception catch (e) {
          AppLog.error(e);
          yield state.copyWith(
            status: FormzStatus.submissionFailure,
          );
        }
      }
    } else if (event is LoginRefreshTokenConnected) {
      try {
        yield state.copyWith(
          status: FormzStatus.submissionInProgress,
        );

        var resultRefreshToken = await futureAppDuration<bool>(
            _identityServerService.refreshToken());

        if (resultRefreshToken) {
          yield state.copyWith(
            status: FormzStatus.submissionSuccess,
          );

          // update deviceID
          _firebaseNotification.updateToken();
        } else {
          throw Exception();
        }
      } on Exception {
        yield state.copyWith(
          status: FormzStatus.pure,
        );
      }
    } else if (event is LoginIntial) {
      add(LoginRefreshTokenConnected());
    } else if (event is LoginPasswordShowOrHide) {
      PasswordLogin password;
      var commonPassword = state.password.value.copyWith(
        isHide: !state.password.value.isHide,
      );

      if (state.password.pure) {
        password = PasswordLogin.pure(
          password: commonPassword,
        );
      } else {
        password = PasswordLogin.dirty(
          password: commonPassword,
        );
      }

      yield state.copyWith(
        password: password,
      );
    }
  }
}
