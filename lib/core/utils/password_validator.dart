bool validatePasswordStrong(String value) {
  String pattern =
      r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@?#\$&*~]).{8,}$';
  RegExp regExp = RegExp(pattern);
  return value.length >= 8 && regExp.hasMatch(value);
}
