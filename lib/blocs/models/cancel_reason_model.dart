import 'package:collector_app/constants/constants.dart';
import 'package:formz/formz.dart';

enum CancelReasonError { invalid }

class CancelReason extends FormzInput<String, CancelReasonError> {
  const CancelReason.dirty([String value = Symbols.empty]) : super.dirty(value);
  const CancelReason.pure([String value = Symbols.empty]) : super.pure(value);

  bool _validate(String value) {
    return value.trim().isNotEmpty;
  }

  @override
  CancelReasonError? validator(String value) {
    return _validate(value) ? null : CancelReasonError.invalid;
  }
}
