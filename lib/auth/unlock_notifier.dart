import 'package:flutter/foundation.dart';

class UnlockNotifier extends ChangeNotifier {
  bool _isUnlocked = false;

  change(bool isUnlocked) {
    _isUnlocked = isUnlocked;
    notifyListeners();
  }
}
