import 'package:openauth/entry/entry.dart';
import 'package:otp/otp.dart';

class TokenGenerator {
  static String compute(Entry entry) {
    switch (entry.type) {
      case OTPType.totp:
        return OTP.generateTOTPCodeString(
            entry.secret, DateTime.now().millisecondsSinceEpoch,
            length: entry.length,
            interval: entry.period,
            algorithm: entry.algorithm,
            isGoogle: entry.isGoogle);
      case OTPType.hotp:
        return OTP.generateHOTPCodeString(entry.secret, entry.counter,
            length: entry.length, algorithm: entry.algorithm);
    }
  }

  static const List<String> steamCharacters = [
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
    'B',
    'C',
    'D',
    'F',
    'G',
    'H',
    'J',
    'K',
    'M',
    'N',
    'P',
    'Q',
    'R',
    'T',
    'V',
    'W',
    'X',
    'Y'
  ];
}
