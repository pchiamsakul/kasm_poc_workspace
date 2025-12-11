import 'package:intl/intl.dart';

extension DateTimeExtension on DateTime {
  String? toFormattedString([String format = 'd MMM yyyy']) {
    try {
      return DateFormat(format).format(this);
    } catch (e) {
      return null;
    }
  }
}
