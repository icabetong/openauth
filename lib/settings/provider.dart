import 'dart:convert';
import 'package:flutter_gen/gen_l10n/translations.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:openauth/theme/core.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum Sort {
  custom,
  nameAscending,
  nameDescending,
  issuerAscending,
  issuerDescending
}

extension SortExtension on Sort {
  static const _custom = "custom";
  static const _nameAscending = "nameAscending";
  static const _nameDescending = "nameDescending";
  static const _issuerAscending = "issuerAscending";
  static const _issuerDescending = "issuerDescending";

  String getLocalization(context) {
    switch (this) {
      case Sort.custom:
        return Translations.of(context)!.sort_custom;
      case Sort.nameAscending:
        return Translations.of(context)!.sort_name_ascending;
      case Sort.nameDescending:
        return Translations.of(context)!.sort_name_descending;
      case Sort.issuerAscending:
        return Translations.of(context)!.sort_issuer_ascending;
      case Sort.issuerDescending:
        return Translations.of(context)!.sort_issuer_descending;
    }
  }

  String get value {
    switch (this) {
      case Sort.custom:
        return _custom;
      case Sort.nameAscending:
        return _nameAscending;
      case Sort.nameDescending:
        return _nameDescending;
      case Sort.issuerAscending:
        return _issuerAscending;
      case Sort.issuerDescending:
        return _issuerDescending;
    }
  }

  static Sort parse(String sort) {
    switch (sort) {
      case _custom:
        return Sort.custom;
      case _nameAscending:
        return Sort.nameAscending;
      case _nameDescending:
        return Sort.nameDescending;
      case _issuerAscending:
        return Sort.issuerAscending;
      case _issuerDescending:
        return Sort.issuerDescending;
      default:
        throw Exception("Invalid sorting value");
    }
  }
}

class Preferences {
  AppTheme theme;
  bool isSecretsHidden;
  bool isAppProtected;
  Sort sort;
  bool isFirstLaunch;

  Preferences({
    required this.theme,
    required this.isSecretsHidden,
    required this.isAppProtected,
    required this.sort,
    required this.isFirstLaunch,
  });

  static Preferences getDefault() {
    return Preferences(
      theme: AppTheme.light,
      isSecretsHidden: defaultSecretsHidden,
      isAppProtected: defaultAppProtected,
      sort: Sort.custom,
      isFirstLaunch: defaultFirstLaunch,
    );
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

  static Future<bool> setTheme(AppTheme theme) async {
    final preferences = await SharedPreferences.getInstance();
    return await preferences.setString(_theme, theme.value.toString());
  }

  static Future<bool> setSecretsHidden(bool isSecretsHidden) async {
    final preferences = await SharedPreferences.getInstance();
    return await preferences.setBool(_isSecretsHidden, isSecretsHidden);
  }

  static Future<bool> setSort(Sort sort) async {
    final preferences = await SharedPreferences.getInstance();
    return await preferences.setString(_sort, sort.value.toString());
  }

  static Future<bool> setFirstLaunch(bool isFirstLaunch) async {
    final preferences = await SharedPreferences.getInstance();
    return await preferences.setBool(_isFirstLaunch, isFirstLaunch);
  }

  static Future<bool> setAppProtected(bool isAppProtected) async {
    final preferences = await SharedPreferences.getInstance();
    return await preferences.setBool(_isAppProtected, isAppProtected);
  }

  static Future<AppTheme> get theme async {
    final preferences = await SharedPreferences.getInstance();
    String? theme = preferences.getString(_theme);
    return theme != null ? AppThemeExtension.parse(theme) : AppTheme.light;
  }

  static Future<bool> get isSecretsHidden async {
    final preferences = await SharedPreferences.getInstance();
    return preferences.getBool(_isSecretsHidden) ??
        Preferences.defaultSecretsHidden;
  }

  static Future<bool> get isAppProtected async {
    final preferences = await SharedPreferences.getInstance();
    return preferences.getBool(_isAppProtected) ??
        Preferences.defaultAppProtected;
  }

  static Future<Sort> get sort async {
    final preferences = await SharedPreferences.getInstance();
    String? sort = preferences.getString(_sort);
    return sort != null ? SortExtension.parse(sort) : Sort.custom;
  }

  static Future<bool> get isFirstLaunch async {
    final preferences = await SharedPreferences.getInstance();
    return preferences.getBool(_isFirstLaunch) ??
        Preferences.defaultFirstLaunch;
  }

  static Future<Preferences> getPreferences() async {
    return Preferences(
      theme: await theme,
      isSecretsHidden: await isSecretsHidden,
      isAppProtected: await isAppProtected,
      sort: await sort,
      isFirstLaunch: await isFirstLaunch,
    );
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
