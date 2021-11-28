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
  Sort sort;
  AppTheme theme;
  bool tapToCopy;
  bool hideTokens;
  bool isSecretsHidden;
  bool isAppProtected;
  bool isFirstRun;

  Preferences({
    required this.sort,
    required this.theme,
    required this.tapToCopy,
    required this.hideTokens,
    required this.isSecretsHidden,
    required this.isAppProtected,
    required this.isFirstRun,
  });

  static Preferences getDefault() {
    return Preferences(
      sort: Sort.custom,
      theme: AppTheme.light,
      tapToCopy: defaultTapToCopy,
      hideTokens: defaultHideTokens,
      isSecretsHidden: defaultSecretsHidden,
      isAppProtected: defaultAppProtected,
      isFirstRun: defaultFirstLaunch,
    );
  }

  static const defaultTapToCopy = true;
  static const defaultHideTokens = false;
  static const defaultSecretsHidden = false;
  static const defaultFirstLaunch = true;
  static const defaultAppProtected = false;
}

class PreferenceHandler {
  static const _sort = "sort";
  static const _theme = "theme";
  static const _tapToCopy = "tapToCopy";
  static const _hideTokens = "hideTokens";
  static const _secretsHidden = "secretsHidden";
  static const _appProtected = "appProtected";
  static const _firstRun = "firstLaunch";

  static Future<bool> setSort(Sort sort) async {
    final preferences = await SharedPreferences.getInstance();
    return await preferences.setString(_sort, sort.value.toString());
  }

  static Future<bool> setTheme(AppTheme theme) async {
    final preferences = await SharedPreferences.getInstance();
    return await preferences.setString(_theme, theme.value.toString());
  }

  static Future<bool> setTapToCopy(bool tapToCopy) async {
    final preferences = await SharedPreferences.getInstance();
    return await preferences.setBool(_tapToCopy, tapToCopy);
  }

  static Future<bool> setHideTokens(bool hideTokens) async {
    final preferences = await SharedPreferences.getInstance();
    return await preferences.setBool(_hideTokens, hideTokens);
  }

  static Future<bool> setSecretsHidden(bool isSecretsHidden) async {
    final preferences = await SharedPreferences.getInstance();
    return await preferences.setBool(_secretsHidden, isSecretsHidden);
  }

  static Future<bool> setAppProtected(bool isAppProtected) async {
    final preferences = await SharedPreferences.getInstance();
    return await preferences.setBool(_appProtected, isAppProtected);
  }

  static Future<bool> setFirstRun(bool isFirstRun) async {
    final preferences = await SharedPreferences.getInstance();
    return await preferences.setBool(_firstRun, isFirstRun);
  }

  static Future<Sort> get sort async {
    final preferences = await SharedPreferences.getInstance();
    String? sort = preferences.getString(_sort);
    return sort != null ? SortExtension.parse(sort) : Sort.custom;
  }

  static Future<AppTheme> get theme async {
    final preferences = await SharedPreferences.getInstance();
    String? theme = preferences.getString(_theme);
    return theme != null ? AppThemeExtension.parse(theme) : AppTheme.light;
  }

  static Future<bool> get tapToCopy async {
    final preferences = await SharedPreferences.getInstance();
    return preferences.getBool(_tapToCopy) ?? Preferences.defaultTapToCopy;
  }

  static Future<bool> get hideTokens async {
    final preferences = await SharedPreferences.getInstance();
    return preferences.getBool(_hideTokens) ?? Preferences.defaultHideTokens;
  }

  static Future<bool> get isSecretsHidden async {
    final preferences = await SharedPreferences.getInstance();
    return preferences.getBool(_secretsHidden) ??
        Preferences.defaultSecretsHidden;
  }

  static Future<bool> get isAppProtected async {
    final preferences = await SharedPreferences.getInstance();
    return preferences.getBool(_appProtected) ??
        Preferences.defaultAppProtected;
  }

  static Future<bool> get isFirstRun async {
    final preferences = await SharedPreferences.getInstance();
    return preferences.getBool(_firstRun) ?? Preferences.defaultFirstLaunch;
  }

  static Future<Preferences> getPreferences() async {
    return Preferences(
      sort: await sort,
      theme: await theme,
      tapToCopy: await tapToCopy,
      hideTokens: await hideTokens,
      isSecretsHidden: await isSecretsHidden,
      isAppProtected: await isAppProtected,
      isFirstRun: await isFirstRun,
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
