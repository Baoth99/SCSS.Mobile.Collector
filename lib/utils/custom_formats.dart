import 'package:collector_app/constants/constants.dart';
import 'package:intl/intl.dart';

class CustomFormats {
  static const String birthday = 'dd/MM/yyyy';
  static String numberFormat(int value) =>
      replaceCommaWithDot(NumberFormat('###,###').format(value));
  static NumberFormat quantityFormat = NumberFormat('##0.##');
  static String removeNotNumber(String string) =>
      string.replaceAll(RegExp(r'[^0-9]'), '');
  static String replaceCommaWithDot(String string) =>
      string.replaceAll(RegExp(r','), '.');
  static String replaceDotWithComma(String string) =>
      string.replaceAll(RegExp(r'\.'), ',');
  static String currencyFormat(int value) => replaceCommaWithDot(
      NumberFormat('###,### ${Symbols.vndSymbolUnderlined}').format(value));
}
