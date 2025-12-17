import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

final ValueNotifier<Locale?> appLocale = ValueNotifier<Locale?>(null);

Future<void> loadSavedLocale() async {
  final prefs = await SharedPreferences.getInstance();
  final code = prefs.getString('app_locale');
  if (code == null || code.isEmpty) {
    return;
  }
  appLocale.value = Locale(code);
}

Future<void> setAppLocale(Locale locale) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('app_locale', locale.languageCode);
  appLocale.value = locale;
}
