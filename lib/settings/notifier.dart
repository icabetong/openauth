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

  changeTheme(AppTheme theme) async {
    _preferences.theme = theme;
    await PreferenceHandler.setTheme(theme);
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

  changeSort(Sort sort) async {
    _preferences.sort = sort;
    await PreferenceHandler.setSort(sort);
    notifyListeners();
  }

  changeFirstLaunch(bool isFirstLaunch) async {
    _preferences.isFirstLaunch = isFirstLaunch;
    await PreferenceHandler.setFirstLaunch(isFirstLaunch);
    notifyListeners();
  }
}
