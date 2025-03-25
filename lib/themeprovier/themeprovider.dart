import 'package:flutter/material.dart';
import 'darkmode.dart';
import 'lightmode.dart';

class ThemeProvider with ChangeNotifier {
  ThemeData _themeData = lightMode; // Początkowy motyw

  ThemeData get themeData => _themeData;

  bool get isDarkMode => _themeData == darkMode;

  set themeData(ThemeData themeData) {
    _themeData = themeData;
    notifyListeners(); // Powiadomienie, że zmienił się motyw
  }

  void toggleTheme() {
    if (_themeData == lightMode) {
      themeData = darkMode;
    } else {
      themeData = lightMode;
    }
  }
}
