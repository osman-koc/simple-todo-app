import 'package:email_validator/email_validator.dart';

class UserHelper {
  static bool isValidEmail(String? email) =>
      email == null || email.length <= 5 || !EmailValidator.validate(email);

  static bool isValidPassword(String? password) =>
      password == null || password.length <= 6;
}
