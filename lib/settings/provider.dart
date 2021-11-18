import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum UserTheme { light, dark, amoled, dracula, nord }

extension UserThemeExtension on UserTheme {
  String get value {
    switch (this) {
      case UserTheme.light:
        return 'light';
      case UserTheme.dark:
        return 'dark';
      case UserTheme.amoled:
        return 'amoled';
      case UserTheme.dracula:
        return 'dracula';
      case UserTheme.nord:
        return 'nord';
    }
  }

  static UserTheme parse(String theme) {
    debugPrint(theme);
    switch (theme) {
      case 'light':
        return UserTheme.light;
      case 'dark':
        return UserTheme.dark;
      case 'amoled':
        return UserTheme.amoled;
      case 'dracula':
        return UserTheme.dracula;
      case 'nord':
        return UserTheme.nord;
      default:
        throw Error();
    }
  }
}

class Preferences {
  UserTheme theme;

  Preferences({this.theme = UserTheme.light});
}

class UserPreferenceHandler {
  SharedPreferences? _preferences;

  static const themeKey = "theme";

  void _initPreferences() async {
    if (_preferences != null) {
      _preferences = await SharedPreferences.getInstance();
    }
  }

  Future<Preferences> getPreferences() async {
    UserTheme _theme = await getTheme();
    return Preferences(theme: _theme);
  }

  Future<UserTheme> getTheme() async {
    _initPreferences();
    String? _theme = _preferences?.getString(UserPreferenceHandler.themeKey);
    return _theme != null ? UserThemeExtension.parse(_theme) : UserTheme.light;
  }

  Future setTheme(UserTheme theme) async {
    _initPreferences();
    return await _preferences?.setString(themeKey, theme.value.toString());
  }
}
