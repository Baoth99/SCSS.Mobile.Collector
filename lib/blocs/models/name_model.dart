import 'package:collector_app/constants/constants.dart';
import 'package:formz/formz.dart';

enum NameError { invalid }

class Name extends FormzInput<String, NameError> {
  const Name.pure([String value = Symbols.empty]) : super.pure(value);
  const Name.dirty([String value = Symbols.empty]) : super.dirty(value);

  bool _validate(String value) {
    return value.isNotEmpty;
  }

  @override
  NameError? validator(String value) {
    return _validate(value) ? null : NameError.invalid;
  }
}
