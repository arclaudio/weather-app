import 'package:intl/intl.dart';

class CustomDateUtils {
  static String getDay(String date) {
    DateTime dt = DateTime.parse(date);
    return DateFormat.EEEE()
        .format(dt); // Returns the day of the week (e.g., "Monday")
  }

  static String getFormattedDate(int date) {
    DateTime dt = DateTime.fromMillisecondsSinceEpoch(date * 1000);
    return DateFormat('MMMM dd, yyyy')
        .format(dt); // Returns the date in format "March 26, 2024"
  }

  static String getFormattedTime(int time) {
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(time * 1000);
    return DateFormat.Hm().format(dateTime);
  }

  static String getFormattedTime2(int time) {
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(time * 1000);
    return DateFormat.jm().format(dateTime);
  }
}
