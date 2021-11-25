import 'package:openauth/entry/entry.dart';
import 'package:otp/otp.dart';

class TokenGenerator {
  static String compute(Entry entry, {int? time}) {
    switch (entry.type) {
      case OTPType.totp:
        return OTP.generateTOTPCodeString(
            entry.secret, time ?? DateTime.now().millisecondsSinceEpoch,
            length: entry.length,
            interval: entry.period,
            algorithm: entry.algorithm,
            isGoogle: entry.isGoogle);
      case OTPType.hotp:
        return OTP.generateHOTPCodeString(entry.secret, entry.counter,
            length: entry.length, algorithm: entry.algorithm);
      case OTPType.steam:
        int totp = OTP.generateTOTPCode(
            entry.secret, time ?? DateTime.now().millisecondsSinceEpoch,
            algorithm: entry.algorithm, isGoogle: entry.isGoogle);

        String code = "";
        for (int i = 0; i < entry.length; i++) {
          code += steamCharacters[totp % steamCharacters.length];
          totp = totp ~/ steamCharacters.length;
        }
        return code;
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
