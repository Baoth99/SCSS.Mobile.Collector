import 'package:collector_app/blocs/events/abstract_event.dart';
import 'package:collector_app/blocs/models/password_model.dart';
import 'package:collector_app/constants/constants.dart';
import 'package:collector_app/log/logger.dart';
import 'package:collector_app/providers/configs/injection_config.dart';
import 'package:collector_app/providers/services/identity_server_service.dart';
import 'package:collector_app/utils/common_function.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

part 'states/forget_password_new_password_state.dart';
part 'events/forget_password_new_password_event.dart';

class ForgetPasswordNewPasswordBloc
    extends Bloc<ForgetPasswordEvent, ForgetPasswordNewPasswordState> {
  ForgetPasswordNewPasswordBloc({
    IdentityServerService? identityServerService,
    required String phone,
    required String token,
  }) : super(ForgetPasswordNewPasswordState(
          phone: phone,
          token: token,
        )) {
    _identityServerService =
        identityServerService ?? getIt.get<IdentityServerService>();
  }
  late IdentityServerService _identityServerService;
  @override
  Stream<ForgetPasswordNewPasswordState> mapEventToState(
      ForgetPasswordEvent event) async* {
    if (event is ForgetPasswordPasswordChange) {
      var password = Password.dirty(
        password: state.password.value.copyWith(
          value: event.password,
        ),
      );

      var repeatPassword = state.repeatPassword.pure
          ? RepeatPassword.pure(
              password: state.repeatPassword.value,
              currentPassword: event.password,
            )
          : RepeatPassword.dirty(
              password: state.repeatPassword.value,
              currentPassword: event.password,
            );

      yield state.copyWith(
        password: password,
        repeatPassword: repeatPassword,
        status: Formz.validate(
          [
            password,
            repeatPassword,
          ],
        ),
      );
    } else if (event is ForgetPasswordRepeatPasswordChanged) {
      var repeatPassword = RepeatPassword.dirty(
        password: state.repeatPassword.value.copyWith(
          value: event.repeatPassword,
        ),
        currentPassword: state.password.value.value,
      );
      yield state.copyWith(
        repeatPassword: repeatPassword,
        status: Formz.validate(
          [
            state.password,
            repeatPassword,
          ],
        ),
      );
    } else if (event is ForgetPasswordPasswordShowOrHide) {
      Password password;
      var commonPassword = state.password.value.copyWith(
        isHide: !state.password.value.isHide,
      );

      if (state.password.pure) {
        password = Password.pure(
          password: commonPassword,
        );
      } else {
        password = Password.dirty(
          password: commonPassword,
        );
      }

      yield state.copyWith(
        password: password,
        status: Formz.validate(
          [
            password,
            state.repeatPassword,
          ],
        ),
      );
    } else if (event is ForgetPasswordRepeatPasswordShowOrHide) {
      RepeatPassword password;
      var commonPassword = state.repeatPassword.value.copyWith(
        isHide: !state.repeatPassword.value.isHide,
      );

      if (state.repeatPassword.pure) {
        password = RepeatPassword.pure(
          password: commonPassword,
          currentPassword: state.password.value.value,
        );
      } else {
        password = RepeatPassword.dirty(
          password: commonPassword,
          currentPassword: state.password.value.value,
        );
      }

      yield state.copyWith(
        repeatPassword: password,
        status: Formz.validate(
          [
            state.password,
            password,
          ],
        ),
      );
    } else if (event is ForgetPasswordSubmmited) {
      Password password = Password.dirty(
        password: state.password.value.copyWith(
          value: state.password.value.value,
        ),
      );
      RepeatPassword repeatPassword = RepeatPassword.dirty(
        password: state.repeatPassword.value.copyWith(
          value: state.repeatPassword.value.value,
        ),
        currentPassword: password.value.value,
      );

      yield state.copyWith(
        password: password,
        repeatPassword: repeatPassword,
        status: Formz.validate(
          [
            password,
            repeatPassword,
          ],
        ),
      );

      if (state.status.isValid) {
        yield state.copyWith(
          status: FormzStatus.submissionInProgress,
        );

        try {
          var result = await futureAppDuration(
            _identityServerService.restorePassword(
              state.phone,
              state.token,
              state.password.value.value,
            ),
          );

          if (result == NetworkConstants.ok200) {
            yield state.copyWith(
              status: FormzStatus.submissionSuccess,
              statusSubmmited: NetworkConstants.ok200,
            );
          } else if (result == 400) {
            yield state.copyWith(
              status: FormzStatus.submissionFailure,
              statusSubmmited: NetworkConstants.badRequest400,
            );
          } else {
            throw Exception('Result is not 400');
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
}
