import 'package:intl/intl.dart' show DateFormat;

String dateFormat(DateTime date) {
  return DateFormat('yyyy-MM-dd').format(date);
}

String timeFormat(DateTime date) {
  return DateFormat('HH:mm').format(date);
}

String dateAndTimeFormat(DateTime date) {
  return DateFormat('yyyy-MM-dd HH:mm').format(date);
}
