import 'package:collector_app/constants/constants.dart';
import 'package:intl/intl.dart';

class CustomFormats {
  static const String birthday = 'dd/MM/yyyy';
  static NumberFormat numberFormat = NumberFormat('###,###');
  static NumberFormat currencyFormat =
      NumberFormat('###,### ${Symbols.vndSymbolText}');
}
