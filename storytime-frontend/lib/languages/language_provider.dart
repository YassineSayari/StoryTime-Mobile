import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app_localizations.dart';

class LanguageProvider extends ChangeNotifier {
  BehaviorSubject<Locale> _appLocale = BehaviorSubject<Locale>.seeded(Locale('en'));

  Stream<Locale> get appLocale => _appLocale.stream;

  Future<void> changeLanguage(BuildContext context, Locale type) async {
    print('Changing language to: $type');
    if (_appLocale.value == type) {
      return;
    }

    _appLocale.add(type);

    // Save the selected language to shared preferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('languageCode', type.languageCode);

    // Reload the app when the language changes
    await AppLocalizations.of(context).load();
  }

  Future<void> loadSavedLanguage(BuildContext context) async {
    // Load the saved language from shared preferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedLanguageCode = prefs.getString('languageCode');

    if (savedLanguageCode != null) {
      await changeLanguage(
        context,
        Locale(savedLanguageCode),
      );
    }
  }
}
