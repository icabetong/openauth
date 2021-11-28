import 'package:flutter/material.dart';
import 'package:openauth/settings/provider.dart';
import 'package:openauth/theme/core.dart';

class PreferenceNotifier extends ChangeNotifier {
  Preferences _preferences = Preferences.getDefault();
  Preferences get preferences => _preferences;

  PreferenceNotifier() {
    load();
  }

  void load() async {
    _preferences = await PreferenceHandler.getPreferences();
    notifyListeners();
  }

  changeSort(Sort sort) async {
    _preferences.sort = sort;
    await PreferenceHandler.setSort(sort);
    notifyListeners();
  }

  changeTheme(AppTheme theme) async {
    _preferences.theme = theme;
    await PreferenceHandler.setTheme(theme);
    notifyListeners();
  }

  changeTapToCopy(bool tapToCopy) async {
    _preferences.tapToCopy = tapToCopy;
    await PreferenceHandler.setTapToCopy(tapToCopy);
    notifyListeners();
  }

  changeHideTokens(bool hideTokens) async {
    _preferences.hideTokens = hideTokens;
    await PreferenceHandler.setHideTokens(hideTokens);
    notifyListeners();
  }

  changeSecretsHidden(bool isSecretsHidden) async {
    _preferences.isSecretsHidden = isSecretsHidden;
    await PreferenceHandler.setSecretsHidden(isSecretsHidden);
    notifyListeners();
  }

  changeProtection(bool isProtected) async {
    _preferences.isAppProtected = isProtected;
    await PreferenceHandler.setAppProtected(isProtected);
    notifyListeners();
  }

  changeFirstRun(bool isFirstRun) async {
    _preferences.isFirstRun = isFirstRun;
    await PreferenceHandler.setFirstRun(isFirstRun);
    notifyListeners();
  }
}
