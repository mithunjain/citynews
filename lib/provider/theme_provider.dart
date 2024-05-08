import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:news/type/types.dart';

class ThemeChanger with ChangeNotifier {
  late String _currentTheme;
  final themeMode = ThemeModeTypes();

  ThemeChanger(this._currentTheme);

  String getTheme() {
    if (_currentTheme == themeMode.autoMode) {
      DateTime now = DateTime.now();
      return now.hour >= 6 && now.hour < 18
          ? themeMode.lightMode
          : themeMode.darkMode;
    }

    return _currentTheme;
  }

  setTheme(String themeModeType) {
    _currentTheme = themeModeType;
    notifyListeners();
  }

  isAutomaticMode() => this._currentTheme == themeMode.autoMode;
}
