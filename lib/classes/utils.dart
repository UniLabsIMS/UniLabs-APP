import 'package:intl/intl.dart';

class Util {
  static DateTime convertToDate(String input) {
    try {
      DateTime d = new DateFormat('yyyy-MM-dd').parseStrict(input);
      return d;
    } catch (e) {
      return null;
    }
  }

  static String convertToString(DateTime date) {
    try {
      String d = new DateFormat('yyyy-MM-dd').format(date);
      return d;
    } catch (e) {
      return null;
    }
  }

  static String setInitialDueDate() {
    var today = DateTime.now();
    var dueDate = today.add(const Duration(days: 14));
    String d = new DateFormat('yyyy-MM-dd').format(dueDate);
    return d;
  }
}
