import 'package:intl/intl.dart';

extension DateOnlyCompare on DateTime? {
  bool isSameDay(DateTime? other) {
    return this != null &&
        other != null &&
        this?.year == other.year &&
        this?.month == other.month &&
        this?.day == other.day;
  }
}

extension FormatExt on DateTime {
  String format(String format) {
    return DateFormat(format).format(this);
  }
}

extension DateFromString on String {
  DateTime? toDateTime(String format) {
    return DateFormat(format).tryParseStrict(this);
  }

  DateTime get parseDateTime {
    return DateTime.parse(this).toLocal();
  }
}

extension Only on DateTime {
  DateTime get onlyDay => DateTime(year, month, day);
  DateTime get onlyMonth => DateTime(year, month);
  DateTime get onlyYear => DateTime(year);
}
