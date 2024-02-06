import 'package:email_validator/email_validator.dart';

class UserHelper {
  static bool isNotValidEmail(String? email) =>
      email == null || email.length <= 5 || !EmailValidator.validate(email);

  static bool isNotValidPassword(String? password) =>
      password == null || password.length <= 7;
}
