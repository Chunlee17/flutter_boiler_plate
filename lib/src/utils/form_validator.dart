class FormValidator {
  static String validateField(String value, {String field, int length}) {
    if (value.isEmpty) {
      return "Please input your $field";
    }
    if (length != null && value.length < length)
      return "$field must be $length characters long";
    return null;
  }

  static String isNumber(String value, {String field}) {
    if (value.isEmpty) {
      return "Please input your $field";
    }
    num asNumber = num.tryParse(value);
    if (asNumber is num) return null;
    return "$field must be a number";
  }

  static String validateConfirmPassword(String value, String newPassword) {
    if (value.isEmpty) {
      return "Please confirm your password";
    }

    if (value.trim() != newPassword.trim())
      return "Confirm password must be the same as password";
    return null;
  }
}
