import 'package:collector_app/constants/constants.dart';
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

extension IntegerExtension on int {
  String toStringLeadingTwoZero() {
    return this.toString().padLeft(2, '0');
  }
}

extension DatetimeExtension on DateTime {
  String toStringApp() {
    String dayOfWeek = VietnameseDate.weekdayMap[weekday] ?? Symbols.empty;
    return '$dayOfWeek, ${day.toStringLeadingTwoZero()} thg $month $year, ${hour.toStringLeadingTwoZero()}:${minute.toStringLeadingTwoZero()}';
  }

  DateTime onlyDate() {
    return DateTime(year, month, day);
  }

  String toStatisticString() {
    return '${day.toStringLeadingTwoZero()}/${month.toStringLeadingTwoZero()}/$year';
  }

  String toOnlyDateString() {
    return '$year-$month-$day';
  }
}
