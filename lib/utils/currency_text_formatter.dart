import 'package:flutter/services.dart';

import 'custom_formats.dart';

class CurrencyTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    String newValueNumberOnly = CustomFormats.removeNotNumber(newValue.text);
    int selectionIndex = newValue.text.length - newValue.selection.extentOffset;

    // Length limit
    if (newValueNumberOnly.length > 8) return oldValue;

    // Check null
    if (newValueNumberOnly.length == 0) {
      return newValue.copyWith(
          text: '0', selection: TextSelection.collapsed(offset: 1));
    } else {
      String newIntFortmated =
          CustomFormats.numberFormat(int.parse(newValueNumberOnly));
      return newValue.copyWith(
        text: CustomFormats.replaceCommaWithDot(newIntFortmated),
        selection: TextSelection.collapsed(
            offset: newIntFortmated.length - selectionIndex),
      );
    }
  }
}
