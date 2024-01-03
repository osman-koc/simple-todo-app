import 'package:flutter/material.dart';
import 'package:simpletodo/util/localization.dart';


class AppLangTranslations {
  final AppLocalizations _appLocalizations;

  AppLangTranslations(this._appLocalizations);

  String get appName => _appLocalizations.translate(key: 'app_name');
  String get search => _appLocalizations.translate(key: 'search');
  String get allTodos => _appLocalizations.translate(key: 'header_allTodos');
  String get addNewItem => _appLocalizations.translate(key: 'add_new_item');
  String get hello => _appLocalizations.translate(key: 'hello');
  String get siginSubText => _appLocalizations.translate(key: 'signin_subtext');
  String get forgotPasswordText =>
      _appLocalizations.translate(key: 'forgot_your_password');
  String get signinButtonText =>
      _appLocalizations.translate(key: 'signin_button_text');
  String get signupButtonText =>
      _appLocalizations.translate(key: 'signup_button_text');
  String get dontHaveAnAccount =>
      _appLocalizations.translate(key: 'dont_have_an_account');
  String get signup => _appLocalizations.translate(key: 'signup');
  String get email => _appLocalizations.translate(key: 'email');
  String get password => _appLocalizations.translate(key: 'password');
  String get signupWithAppText =>
      _appLocalizations.translate(key: 'signup_with_app_text');
  String get backToLogin => _appLocalizations.translate(key: 'back_to_login');
  String get delete => _appLocalizations.translate(key: 'delete');
  String get areYouSureForDelete =>
      _appLocalizations.translate(key: 'are_you_sure_for_delete');
  String get no => _appLocalizations.translate(key: 'no');
  String get yes => _appLocalizations.translate(key: 'yes');
  String get emailOrPasswordWrong =>
      _appLocalizations.translate(key: 'email_password_wrong');
  String get invalidEmail => _appLocalizations.translate(key: 'invalid_email');
  String get invalidPassword =>
      _appLocalizations.translate(key: 'invalid_password');
  String get userNotSaved => _appLocalizations.translate(key: 'user_not_saved');
  String get errorSave => _appLocalizations.translate(key: "error_save");
}

extension AppLangContextExtension on BuildContext {
  AppLangTranslations get translate =>
      AppLangTranslations(AppLocalizations.of(this));
}
