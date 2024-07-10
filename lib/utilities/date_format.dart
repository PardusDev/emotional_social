import 'package:intl/intl.dart';

String formatAccordingToNow(DateTime dateTime) {
  final now = DateTime.now();

  // The date is today?
  if (dateTime.year == now.year && dateTime.month == now.month && dateTime.day == now.day) {
    return DateFormat.Hm().format(dateTime);
  }

  // The date is current year?
  if (dateTime.year == now.year) {
    return DateFormat('dd/MM').format(dateTime);
  }

  // All other dates
  return DateFormat.yMMMd().format(dateTime);
}