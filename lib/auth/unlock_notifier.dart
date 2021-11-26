import 'package:flutter/foundation.dart';
import 'package:openauth/settings/provider.dart';

class UnlockNotifier extends ChangeNotifier {
  bool _isUnlocked = false;
  bool _isProtected = false;

  bool get isAuthenticated => _isUnlocked;
  bool get requireAuthentication => _isProtected;

  UnlockNotifier() {
    _load();
  }

  void _load() async {
    _isProtected = await PreferenceHandler.isAppProtected;
    notifyListeners();
  }

  change(bool isUnlocked) {
    _isUnlocked = isUnlocked;
    notifyListeners();
  }
}
