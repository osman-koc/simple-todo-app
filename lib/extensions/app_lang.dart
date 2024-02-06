import 'package:flutter/material.dart';
import 'package:simpletodo/util/localization.dart';


class AppLangTranslations {
  final AppLocalizations _appLocalizations;

  AppLangTranslations(this._appLocalizations);

  String get appName => _appLocalizations.translate(key: 'app_name');
  String get appDeveloper => _appLocalizations.translate(key: 'app_developer');
  String get appWebsite => _appLocalizations.translate(key: 'app_website');
  String get appMail => _appLocalizations.translate(key: 'app_email');
  String get loading => _appLocalizations.translate(key: 'loading');
  String get osmkocCom => _appLocalizations.translate(key: 'osmkoccom');
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
  String get errorSave => _appLocalizations.translate(key: 'error_save');
  String get myAccount => _appLocalizations.translate(key: 'my_account');
  String get logout => _appLocalizations.translate(key: 'logout');
  String get close => _appLocalizations.translate(key: 'close');
  String get home => _appLocalizations.translate(key: 'home');
  String get menu => _appLocalizations.translate(key: 'menu');
  String get about => _appLocalizations.translate(key: 'about');
  String get errorLogout => _appLocalizations.translate(key: 'error_logout_message');
  String get aboutAppTitle => _appLocalizations.translate(key: 'about_app_title');
  String get developedBy => _appLocalizations.translate(key: 'developedby');
  String get contact => _appLocalizations.translate(key: 'contact');
  String get send => _appLocalizations.translate(key: 'send');
  String get passwordResetHeaderText => _appLocalizations.translate(key: 'password_reset_header_text');
  String get successSendMail => _appLocalizations.translate(key: 'success_send_mail_message');
  String get todoItemEmptyMessage => _appLocalizations.translate(key: 'todo_item_empty_message');
  String get todoItemSuccessMessage => _appLocalizations.translate(key: 'todo_item_success_message');
  String get deleteItemSuccessMessage => _appLocalizations.translate(key: 'delete_item_success_message');
  String get deleteItemErrorMessage => _appLocalizations.translate(key: 'delete_item_error_message');
  String get todoItemUpdateHeader => _appLocalizations.translate(key: 'todo_item_update_header');
  String get todoItemExistsMesage => _appLocalizations.translate(key: 'todo_item_exists_message');
  String get enterNewValue => _appLocalizations.translate(key: 'enter_new_value');
  String get cancel => _appLocalizations.translate(key: 'cancel');
  String get save => _appLocalizations.translate(key: 'save');
  String get updateDoneItemError => _appLocalizations.translate(key: 'update_done_item_error_message');
  String get noRecords => _appLocalizations.translate(key: 'no_records_found');
}

extension AppLangContextExtension on BuildContext {
  AppLangTranslations get translate =>
      AppLangTranslations(AppLocalizations.of(this));
}
