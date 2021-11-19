class Entry {
  final String entryId;
  final String secret;
  final String issuer;
  final String name;
  final int length;
  final int period;
  final int counter;
  final OTPType type;
  final String algorithm;
  final bool isGoogle;

  Entry(
    this.secret,
    this.issuer,
    this.name, {
    this.entryId = "",
    this.type = OTPType.TOTP,
    this.length = defaultLength,
    this.period = defaultPeriod,
    this.counter = 0,
    this.algorithm = "SHA21",
    this.isGoogle = false,
  });

  static const jsonSecret = "secret";
  static const jsonIssuer = "issuer";
  static const jsonName = "name";
  static const jsonLength = "length";
  static const jsonPeriod = "period";
  static const jsonCounter = "counter";
  static const jsonType = "type";
  static const jsonAlgorithm = "algorithm";
  static const jsonIsGoogle = "isGoogle";

  static const defaultPeriod = 30;
  static const defaultLength = 6;
}

// ignore: constant_identifier_names
enum OTPType { TOTP, HOTP }
