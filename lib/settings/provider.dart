import 'package:shared_preferences/shared_preferences.dart';

enum UserTheme { light, dark }

extension UserThemeExtension on UserTheme {
  String get value {
    switch (this) {
      case UserTheme.light:
        return 'light';
      case UserTheme.dark:
        return 'dark';
    }
  }

  static UserTheme parse(String theme) {
    switch (theme) {
      case 'light':
        return UserTheme.light;
      case 'dark':
        return UserTheme.dark;
      default:
        throw Error();
    }
  }
}

class UserPreferences {
  late SharedPreferences _preferences;

  static const themeKey = "theme";

  Future<UserTheme> getTheme() async {
    _preferences = await SharedPreferences.getInstance();
    String? _theme = _preferences.getString(UserPreferences.themeKey);
    return _theme != null ? UserThemeExtension.parse(_theme) : UserTheme.light;
  }

  Future setTheme(UserTheme theme) async {
    _preferences = await SharedPreferences.getInstance();
    return await _preferences.setString(themeKey, theme.toString());
  }
}
