import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:openauth/settings/provider.dart';

void main() {
  test('Passphrase Input to Secure Storage', () async {
    String passphrase = "stormy-day";
    await PassphraseHandler.setPassphrase(passphrase);
    String? result = await PassphraseHandler.getPassphrase();
    expect(passphrase, equals(base64Decode(result!)));
  });
}
