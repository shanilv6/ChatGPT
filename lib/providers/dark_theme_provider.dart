import 'package:flutter/material.dart';

import '../services/dark_theme_prefs.dart';

class WhiteThemeProvider with ChangeNotifier {
  WhiteThemePrefs whiteThemePrefs = WhiteThemePrefs();
  bool _whiteTheme = false;
  bool get getWhiteTheme => _whiteTheme;
  set setWhiteTheme(bool value) {
    _whiteTheme = value;
    whiteThemePrefs.setWhiteTheme(value);
    notifyListeners();
  }
}
