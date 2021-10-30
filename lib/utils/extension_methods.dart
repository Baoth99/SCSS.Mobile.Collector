import 'package:intl/intl.dart' show NumberFormat;

extension IntExtension on int {
  String toAppPrice() {
    var f = NumberFormat.currency(locale: 'vi_VN', symbol: '₫');
    return f.format(this);
  }
}
