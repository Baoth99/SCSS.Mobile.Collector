import 'package:collector_app/constants/constants.dart';
import 'package:formz/formz.dart';

enum LoginPhoneNumberError { empty }

class LoginPhoneNumber extends FormzInput<String, LoginPhoneNumberError> {
  const LoginPhoneNumber.pure([String value = Symbols.empty])
      : super.pure(value);
  const LoginPhoneNumber.dirty([String value = Symbols.empty])
      : super.dirty(value);

  bool _validate(String value) {
    return value.isNotEmpty;
  }

  @override
  LoginPhoneNumberError? validator(String value) {
    return _validate(value) ? null : LoginPhoneNumberError.empty;
  }
}
