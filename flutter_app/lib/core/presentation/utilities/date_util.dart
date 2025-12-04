import 'package:intl/intl.dart';

class DateUtil {
  static String formatTime(DateTime dateTime) {
    final DateFormat formatter = DateFormat('HH:mm');
    return formatter.format(dateTime);
  }
}
