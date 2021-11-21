import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Passkey conversion to byte array', () {
    String passkey = "password";
    final key = passkey.codeUnits;
    expect(utf8.decode(key), equals(passkey));
  });
}
