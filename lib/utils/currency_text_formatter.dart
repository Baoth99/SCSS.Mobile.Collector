import 'package:flutter/services.dart';

import 'custom_formats.dart';

class CurrencyTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.replaceAll(RegExp(r'[^0-9]'), '').length > 8)
      return oldValue;
    int? newInt = int.tryParse(newValue.text.replaceAll(RegExp(r'[^0-9]'), ''));
    if (newInt == null) {
      return TextEditingValue(
          text: '0', selection: TextSelection.collapsed(offset: 1));
    } else {
      String newIntFortmated = CustomFormats.numberFormat.format(newInt).trim();
      return TextEditingValue(
          text: newIntFortmated,
          selection: TextSelection.collapsed(offset: newIntFortmated.length));
    }
  }
}
