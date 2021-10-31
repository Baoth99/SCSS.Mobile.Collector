import 'package:collector_app/constants/constants.dart';
import 'package:formz/formz.dart';

enum OTPCodeError { invalid }

class OTPCode extends FormzInput<String, OTPCodeError> {
  const OTPCode.pure([String value = Symbols.empty]) : super.pure(value);
  const OTPCode.dirty([String value = Symbols.empty]) : super.dirty(value);

  static bool _validate(String value) {
    return RegExp(RegexConstants.otpCode).hasMatch(value);
  }

  @override
  OTPCodeError? validator(String value) {
    return _validate(value) ? null : OTPCodeError.invalid;
  }
}
