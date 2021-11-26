import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:openauth/theme/core.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Preferences {
  AppTheme theme;
  bool isSecretsHidden;
  bool isFirstLaunch;
  bool isAppProtected;

  Preferences(
      {required this.theme,
      required this.isSecretsHidden,
      required this.isFirstLaunch,
      required this.isAppProtected});

  static Preferences getDefault() {
    return Preferences(
        theme: AppTheme.light,
        isSecretsHidden: true,
        isFirstLaunch: false,
        isAppProtected: false);
  }

  static const defaultSecretsHidden = false;
  static const defaultFirstLaunch = true;
  static const defaultAppProtected = false;
}

class PreferenceHandler {
  static const _theme = "theme";
  static const _isSecretsHidden = "isSecretsHidden";
  static const _isAppProtected = "isAppProtected";
  static const _sort = "sort";
  static const _isFirstLaunch = "isFirstLaunch";

  static Future<AppTheme> getTheme() async {
    final preferences = await SharedPreferences.getInstance();
    String? theme = preferences.getString(_theme);
    return theme != null ? AppThemeExtension.parse(theme) : AppTheme.light;
  }

  static Future<bool> setTheme(AppTheme theme) async {
    final preferences = await SharedPreferences.getInstance();
    return await preferences.setString(_theme, theme.value.toString());
  }

  static Future<bool> getSecretsHidden() async {
    final preferences = await SharedPreferences.getInstance();
    return preferences.getBool(_isSecretsHidden) ??
        Preferences.defaultSecretsHidden;
  }

  static Future<bool> setSecretsHidden(bool isSecretsHidden) async {
    final preferences = await SharedPreferences.getInstance();
    return await preferences.setBool(_isSecretsHidden, isSecretsHidden);
  }

  static Future<bool> getFirstLaunch() async {
    final preferences = await SharedPreferences.getInstance();
    return preferences.getBool(_isFirstLaunch) ??
        Preferences.defaultFirstLaunch;
  }

  static Future<bool> setFirstLaunch(bool isFirstLaunch) async {
    final preferences = await SharedPreferences.getInstance();
    return await preferences.setBool(_isFirstLaunch, isFirstLaunch);
  }

  static Future<bool> getAppProtected() async {
    final preferences = await SharedPreferences.getInstance();
    return preferences.getBool(_isAppProtected) ??
        Preferences.defaultAppProtected;
  }

  static Future<bool> setAppProtected(bool isAppProtected) async {
    final preferences = await SharedPreferences.getInstance();
    return await preferences.setBool(_isAppProtected, isAppProtected);
  }

  static Future<Preferences> getPreferences() async {
    return Preferences(
        theme: await getTheme(),
        isSecretsHidden: await getSecretsHidden(),
        isFirstLaunch: await getFirstLaunch(),
        isAppProtected: await getAppProtected());
  }
}

class PassphraseHandler {
  static const _accessControl = "access";

  static Future setPassphrase(String password) async {
    const storage = FlutterSecureStorage();
    await storage.write(
        key: _accessControl, value: base64Encode(password.codeUnits));
  }

  static Future<String?> getPassphrase() async {
    const storage = FlutterSecureStorage();
    return await storage.read(key: _accessControl);
  }
}
