import 'package:collector_app/blocs/events/abstract_event.dart';
import 'package:collector_app/blocs/models/gender_model.dart';
import 'package:collector_app/blocs/models/name_model.dart';
import 'package:collector_app/blocs/models/password_model.dart';
import 'package:collector_app/constants/constants.dart';
import 'package:collector_app/log/logger.dart';
import 'package:collector_app/providers/configs/injection_config.dart';
import 'package:collector_app/providers/services/firebase_service.dart';
import 'package:collector_app/providers/services/identity_server_service.dart';
import 'package:collector_app/utils/common_function.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
part 'states/signup_information_state.dart';
part 'events/signup_information_event.dart';

class SignupInformationBloc
    extends Bloc<SignupInformationEvent, SignupInformationState> {
  SignupInformationBloc({
    IdentityServerService? identityServerService,
    FirebaseNotification? firebaseNotification,
    required String phone,
    required String token,
  }) : super(SignupInformationState(
          phone: phone,
          token: token,
        )) {
    _identityServerService =
        identityServerService ?? getIt.get<IdentityServerService>();
    _firebaseNotification =
        firebaseNotification ?? getIt.get<FirebaseNotification>();
  }
  late final IdentityServerService _identityServerService;
  late final FirebaseNotification _firebaseNotification;
  @override
  Stream<SignupInformationState> mapEventToState(
      SignupInformationEvent event) async* {
    if (event is SignupInformationNameChanged) {
      var name = Name.dirty(
        event.name,
      );
      yield state.copyWith(
        name: name,
        status: Formz.validate(
          [
            name,
            state.password,
            state.repeatPassword,
          ],
        ),
      );
    } else if (event is SignupInformationGenderChanged) {
      yield state.copyWith(
        gender: event.gender,
      );
    } else if (event is SignupInformationPasswordChanged) {
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
            state.name,
            password,
            repeatPassword,
          ],
        ),
      );
    } else if (event is SignupInformationRepeatPasswordChanged) {
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
            state.name,
            state.password,
            repeatPassword,
          ],
        ),
      );
    } else if (event is SignupInformationPasswordShowOrHide) {
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
      );
    } else if (event is SignupInformationRepeatPasswordShowOrHide) {
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
      );
    } else if (event is SignupInformationSubmmited) {
      Name name = Name.dirty(state.name.value);
      Gender gender = state.gender;
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
        name: name,
        gender: gender,
        password: password,
        repeatPassword: repeatPassword,
      );

      if (state.status.isValid) {
        yield state.copyWith(
          status: FormzStatus.submissionInProgress,
        );

        try {
          var result = await futureAppDuration(
            _identityServerService.register(
              state.token,
              state.phone,
              state.password.value.value,
              state.name.value,
              state.gender,
              await _firebaseNotification.getToken() ?? Symbols.empty,
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
