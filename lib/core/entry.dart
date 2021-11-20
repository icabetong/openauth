import 'package:hive/hive.dart';
part 'entry.g.dart';

@HiveType(typeId: 0)
class Entry {
  @HiveField(0)
  final String entryId;
  @HiveField(1)
  final String secret;
  @HiveField(2)
  final String issuer;
  @HiveField(3)
  final String name;
  @HiveField(4)
  final int length;
  @HiveField(5)
  final int period;
  @HiveField(6)
  final int counter;
  @HiveField(7)
  final OTPType type;
  @HiveField(8)
  final String algorithm;
  @HiveField(9)
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
