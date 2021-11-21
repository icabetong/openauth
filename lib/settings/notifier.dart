import 'package:flutter/material.dart';
import 'package:openauth/settings/provider.dart';

class PreferenceNotifier extends ChangeNotifier {
  final UserPreferenceHandler _handler = UserPreferenceHandler();
  Preferences _preferences = Preferences();
  Preferences get preferences => _preferences;

  PreferenceNotifier() {
    load();
  }

  void load() async {
    _preferences = await _handler.getPreferences();
  }

  changeTheme(UserTheme theme) {
    _preferences.theme = theme;
    _handler.setTheme(theme);
    notifyListeners();
  }

  changeSecretsHidden(bool isSecretsHidden) {
    _preferences.isSecretsHidden = isSecretsHidden;
    _handler.setSecretsHidden(isSecretsHidden);
    notifyListeners();
  }

  changeFirstLaunch(bool isFirstLaunch) {
    _preferences.isFirstLaunch = isFirstLaunch;
    _handler.setFirstLaunch(isFirstLaunch);
    notifyListeners();
  }
}
