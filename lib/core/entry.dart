class Entry {
  static const jsonSecret = "secret";
  static const jsonIssuer = "issuer";
  static const jsonName = "name";
  static const jsonPeriod = "period";
  static const jsonCounter = "counter";
  static const jsonDigits = "digits";
  static const jsonType = "type";
  static const jsonAlgorithm = "algorithm";
}

// ignore: constant_identifier_names
enum OTPType { TOTP, HOTP }
