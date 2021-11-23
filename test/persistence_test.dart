import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:openauth/settings/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  test('Passphrase Input to Secure Storage', () async {
    String passphrase = "stormy-day";
    await PassphraseHandler.setPassphrase(passphrase);
    String? result = await PassphraseHandler.getPassphrase();
    expect(passphrase, equals(base64Decode(result!)));
  });

  test('SharedPreference Persistence Test', () async {
    String name = "Jack";
    final _sharedPreferences = await SharedPreferences.getInstance();
    await _sharedPreferences.setString("name", name);

    expect(name, _sharedPreferences.getString("name"));
  });
}