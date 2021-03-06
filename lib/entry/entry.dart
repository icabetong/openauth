import 'package:hive/hive.dart';
import 'package:openauth/shared/tools.dart';
import 'package:otp/otp.dart';
part 'entry.g.dart';

@HiveType(typeId: 0)
class Entry extends HiveObject {
  @HiveField(0)
  String entryId;
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
  int counter;
  @HiveField(7)
  final OTPType type;
  @HiveField(8)
  final Algorithm algorithm;
  @HiveField(9)
  final bool isGoogle;

  Entry(
    this.secret,
    this.issuer,
    this.name, {
    this.entryId = "",
    this.length = defaultLength,
    this.period = defaultPeriod,
    this.counter = 0,
    this.type = OTPType.totp,
    this.algorithm = Algorithm.SHA1,
    this.isGoogle = true,
  }) {
    if (entryId.trim().isEmpty) {
      entryId = randomId();
    }
  }

  Entry copyWith({
    String? secret,
    String? issuer,
    String? name,
    String? entryId,
    int? length,
    int? period,
    int? counter,
    OTPType? type,
    Algorithm? algorithm,
    bool? isGoogle,
  }) {
    return Entry(
      secret ?? this.secret,
      issuer ?? this.issuer,
      name ?? this.name,
      entryId: entryId ?? this.entryId,
      length: length ?? this.length,
      period: period ?? this.period,
      counter: counter ?? this.counter,
      type: type ?? this.type,
      algorithm: algorithm ?? this.algorithm,
      isGoogle: isGoogle ?? this.isGoogle,
    );
  }

  Map<String, dynamic> toJson() => {
        jsonSecret: secret,
        jsonIssuer: issuer,
        jsonName: name,
        jsonEntryId: entryId,
        jsonLength: length,
        jsonPeriod: period,
        jsonCounter: counter,
        jsonType: type.value,
        jsonAlgorithm: algorithm.value,
        jsonIsGoogle: isGoogle,
      };

  Entry.fromJson(Map<String, dynamic> json)
      : secret = json[jsonSecret],
        issuer = json[jsonIssuer],
        name = json[jsonName],
        entryId = json[jsonEntryId],
        type = OTPTypeExtension.parse(json[jsonType]),
        length = int.parse(json[jsonLength]),
        period = int.parse(json[jsonPeriod]),
        counter = int.parse(json[jsonCounter]),
        algorithm = json[jsonAlgorithm],
        isGoogle = json[jsonIsGoogle];

  factory Entry.fromString(String contents) {
    contents = contents.replaceFirst("otpauth", "http");
    Uri uri = Uri.parse(contents);

    if (!uri.isScheme("http")) {
      throw Error();
    }

    OTPType type;
    switch (uri.host) {
      case OTPTypeExtension.totp:
        type = OTPType.totp;
        break;
      case OTPTypeExtension.hotp:
        type = OTPType.hotp;
        break;
      case OTPTypeExtension.steam:
        type = OTPType.steam;
        break;
      default:
        throw Error();
    }
    final parameters = uri.queryParameters;
    final secret = parameters[jsonSecret];
    final issuer = parameters[jsonIssuer];
    final algorithm = parameters[jsonAlgorithm];
    final length = parameters[jsonLength];
    final period = parameters[jsonPeriod];
    String name = _getStrippedLabel(issuer, uri.path.substring(1));

    if (secret == null || secret.isEmpty) throw Error();
    if (issuer == null) throw Error();

    return Entry(
      secret,
      issuer,
      name,
      type: type,
      length: length != null ? int.parse(length) : defaultLength,
      period: period != null ? int.parse(period) : defaultPeriod,
      algorithm: AlgorithmExtension.parse(algorithm),
    );
  }

  static String _getStrippedLabel(String? issuer, String label) {
    if (issuer == null || issuer.isEmpty || !label.startsWith(issuer + ":")) {
      return label.trim();
    } else {
      return label.substring(issuer.length + 1).trim();
    }
  }

  static const jsonSecret = "secret";
  static const jsonIssuer = "issuer";
  static const jsonName = "name";
  static const jsonEntryId = "entryId";
  static const jsonLength = "length";
  static const jsonPeriod = "period";
  static const jsonCounter = "counter";
  static const jsonType = "type";
  static const jsonAlgorithm = "algorithm";
  static const jsonIsGoogle = "isGoogle";

  static const defaultPeriod = 30;
  static const defaultLength = 6;
  static const defaultCounter = 0;
}

@HiveType(typeId: 1)
enum OTPType {
  @HiveField(0)
  totp,
  @HiveField(1)
  hotp,
  @HiveField(2)
  steam
}

extension OTPTypeExtension on OTPType {
  static const totp = 'totp';
  static const hotp = 'hotp';
  static const steam = 'steam';

  String get value {
    switch (this) {
      case OTPType.totp:
        return totp;
      case OTPType.hotp:
        return hotp;
      case OTPType.steam:
        return steam;
    }
  }

  static OTPType parse(String? otpType) {
    switch (otpType) {
      case totp:
        return OTPType.totp;
      case hotp:
        return OTPType.hotp;
      case steam:
        return OTPType.steam;
      default:
        throw Exception();
    }
  }
}

extension AlgorithmExtension on Algorithm {
  static const sha1 = "SHA1";
  static const sha256 = "SHA256";
  static const sha512 = "SHA512";

  String get value {
    switch (this) {
      case Algorithm.SHA1:
        return sha1;
      case Algorithm.SHA256:
        return sha256;
      case Algorithm.SHA512:
        return sha512;
    }
  }

  static Algorithm parse(String? algorithm) {
    switch (algorithm) {
      case AlgorithmExtension.sha1:
        return Algorithm.SHA1;
      case AlgorithmExtension.sha256:
        return Algorithm.SHA256;
      case AlgorithmExtension.sha512:
        return Algorithm.SHA512;
      default:
        return Algorithm.SHA1;
    }
  }
}

class AlgorithmAdapter extends TypeAdapter<Algorithm> {
  @override
  Algorithm read(BinaryReader reader) {
    final _algorithm = reader.read();
    switch (_algorithm) {
      case AlgorithmExtension.sha1:
        return Algorithm.SHA1;
      case AlgorithmExtension.sha256:
        return Algorithm.SHA256;
      case AlgorithmExtension.sha512:
        return Algorithm.SHA512;
      default:
        throw Error();
    }
  }

  @override
  int get typeId => 3;

  @override
  void write(BinaryWriter writer, Algorithm obj) {
    writer.write(obj.toString().split('.').last);
  }
}
