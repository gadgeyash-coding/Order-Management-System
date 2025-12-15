import 'package:order_managment_system/core/utils/constants.dart';

class Validators {
  static String? email(String? value) {
    if (value == null || value.isEmpty) return AppConstants.emailRequired;
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return AppConstants.enterValidEmail;
    }
    return null;
  }

  static String? password(String? value) {
    if (value == null || value.isEmpty) return AppConstants.passwordRequired;
    if (value.length < 6) return AppConstants.minimumCharacters;
    return null;
  }

  static String? required(String? value, String field) {
    if (value == null || value.isEmpty) return '$field ${AppConstants.required}';
    return null;
  }

  static String? amount(String? value) {
    if (value == null || value.isEmpty) return AppConstants.amountRequired;
    if (double.tryParse(value) == null || double.parse(value) <= 0) {
      return AppConstants.enterValidAmount;
    }
    return null;
  }
}