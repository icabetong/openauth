import 'package:flutter_test/flutter_test.dart';
import 'package:openauth/entry/entry.dart';
import 'package:openauth/shared/token.dart';
import 'package:otp/otp.dart';

void main() {
  const seconds = 45410085 * 30;
  const time = seconds * 1000;
  const issuer = 'Corporate';
  const name = 'Antonio Luna';
  const secret = 'JBSWY3DPEHPK3PXP';

  group('OTP Generation Tests', () {
    final entry = Entry(secret, issuer, name,
        algorithm: Algorithm.SHA256, isGoogle: false);

    test('Generated code for 03-03-13 09:22:30+0000', () {
      final code = TokenGenerator.compute(entry, time: time);
      expect(code, equals('637305'));
    });

    test('Generated code for 03-03-13 09:22:30+0000 with length of 7', () {
      final _entry = entry.copyWith(length: 7);
      final code = TokenGenerator.compute(_entry, time: time + 30000);
      expect(code, equals('1203843'));
    });

    test('Generated code for counter 7', () {
      final _entry = entry.copyWith(
          type: OTPType.hotp, counter: 7, algorithm: Algorithm.SHA1);
      final code = TokenGenerator.compute(_entry);
      expect(code, equals('449891'));
    });

    test('Generated code for counter 7 using SHA256', () {
      final _entry = entry.copyWith(type: OTPType.hotp, counter: 7);
      final code = TokenGenerator.compute(_entry);
      expect(code, equals('346239'));
    });
  });
}
