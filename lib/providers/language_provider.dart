import 'package:flutter/material.dart';

class LanguageProvider extends ChangeNotifier {
  Locale _locale = const Locale('ar', 'SA');
  
  Locale get locale => _locale;
  
  void setLocale(Locale newLocale) {
    _locale = newLocale;
    notifyListeners();
  }
}