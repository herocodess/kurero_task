import 'package:intl/intl.dart';

class Helper {
  static String get defaultAvatarUrl =>
      'https://cdn.pixabay.com/photo/2016/08/08/09/17/avatar-1577909_960_720.png';
  static String getFirstNumber(String email) {
    if (email.isEmpty || !checkIfAlphaNumeric(email)) {
      return '';
    }
    return email.replaceAll(RegExp(r'[^0-9]'), '').substring(0, 1);
  }

  static bool checkIfAlphaNumeric(String str) {
    return RegExp(r'^[a-zA-Z0-9]+$').hasMatch(str);
  }

  static String getUserInitialsFromEmail(String email) {
    String firstCharacter = email.substring(0, 1);
    String firstNumber = '';
    if (checkIfAlphaNumeric(email)) {
      firstNumber = getFirstNumber(email);
      return firstCharacter + firstNumber;
    }
    return firstCharacter;
  }

  static String formatTimeStamp(DateTime timestamp) {
    return DateFormat('MMM dd, yyyy - hh:mm a').format(timestamp);
  }
}
