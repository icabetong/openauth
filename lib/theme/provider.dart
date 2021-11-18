import 'package:flutter/material.dart';
import 'package:openauth/settings/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  final String key = UserPreferences.themeKey;
  final UserPreferences _preferences = UserPreferences();
  late UserTheme _userTheme;
  UserTheme get userTheme => _userTheme;

  ThemeProvider() {
    _userTheme = UserTheme.light;
    loadFromPreferences();
  }

  void loadFromPreferences() async {
    _userTheme = await _preferences.getTheme();
  }

  change() {
    _userTheme =
        _userTheme != UserTheme.light ? UserTheme.light : UserTheme.dark;
    notifyListeners();
    _preferences.setTheme(_userTheme);
  }
}
