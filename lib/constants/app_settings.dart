import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:simpletodo/constants/app_font_styles.dart';
import 'package:simpletodo/util/localization.dart';

class AppSettings {
  static final ThemeData lightTheme = ThemeData(
    fontFamily: AppFontStyles.exo,
    brightness: Brightness.light,
  );

  static final ThemeData darkTheme = ThemeData(
    fontFamily: AppFontStyles.exo,
    brightness: Brightness.dark,
  );

  static const List<Locale> supportedLocales = [
    Locale('en'),
    Locale('tr'),
  ];

  static const List<LocalizationsDelegate> localizationsDelegates = [
    AppLocalizations.delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ];

  static Locale? localeResolutionCallback(locale, supportedLocales) {
    if (locale != null) {
      final currentLocale = supportedLocales
          .firstWhere((x) => x.languageCode == locale.languageCode);
      if (currentLocale != null) return currentLocale;
    }
    return supportedLocales.first;
  }
}
