import 'package:intl/intl.dart' show NumberFormat;

extension IntExtension on int {
  String toAppPrice() {
    var f = NumberFormat.currency(locale: 'vi_VN', symbol: '₫');
    return f.format(this);
  }
}

extension DoubleExtension on double {
  String toStringAndRemoveFractionalIfCan() {
    var value = toInt();
    if (value == this) {
      return value.toString();
    }
    return toString();
  }
}
