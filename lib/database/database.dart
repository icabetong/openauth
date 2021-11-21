import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:openauth/core/entry.dart';
import 'package:openauth/database/repository.dart';

class HiveDatabase {
  static const _encryptionKey = "encryptionKey";

  static Future init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(EntryAdapter());
    Hive.registerAdapter(OTPTypeAdapter());
    Hive.registerAdapter(AlgorithmAdapter());

    const FlutterSecureStorage storage = FlutterSecureStorage();
    bool containsKey = await storage.containsKey(key: _encryptionKey);
    if (!containsKey) {
      final encryptionKey = Hive.generateSecureKey();
      await storage.write(
          key: _encryptionKey, value: base64UrlEncode(encryptionKey));
    }

    String? codedKey = await storage.read(key: _encryptionKey);
    if (codedKey != null) {
      final key = base64Url.decode(codedKey);
      await EntryRepository.open(key);
    }
  }
}
