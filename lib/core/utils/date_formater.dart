import 'package:intl/intl.dart';

String formatDate(dynamic date) {
  date ??= DateTime.now();

  if (date is DateTime) {
    return DateFormat('yyyy-MM-dd').format(date);
  }
  DateTime dateTime = DateTime.parse(date);
  String formattedDateTime = DateFormat('yyyy-MM-dd').format(dateTime);
  return formattedDateTime;
}

String? formatTime(dynamic time) {
  if (time == null) {
    return time;
  }
  if (time is DateTime) {
    return DateFormat('HH:mm').format(time);
  }
  DateTime dateTime = DateTime.parse(time);
  String formattedDateTime = DateFormat('HH:mm').format(dateTime);
  return formattedDateTime;
}
