import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:openauth/entry/entry.dart';

abstract class Repository<T> {
  Future put(T data);
  Future remove(T data);
  List<T> fetch();
}

class EntryRepository extends Repository<Entry> {
  static const _boxName = "main";
  final _box = Hive.box<Entry>(_boxName);
  List<Entry> _entries = [];

  static Future<bool> open(key) async {
    if (!Hive.isBoxOpen(_boxName)) {
      await Hive.openBox<Entry>(_boxName, encryptionCipher: HiveAesCipher(key));
    }
    return true;
  }

  EntryRepository() {
    _entries = _box.values.toList();
  }

  @override
  Future put(Entry data) async {
    final index = _entries.indexWhere((e) => e.entryId == data.entryId);
    // if exists in the entries
    if (index > -1) {
      _entries[index] = data;
    } else {
      _entries.add(data);
    }
    await _box.clear();
    return await _box.addAll(_entries);
  }

  @override
  Future remove(Entry data) async {
    _entries.removeWhere((e) => e.entryId == data.entryId);
    await _box.clear();
    return await _box.addAll(_entries);
  }

  @override
  List<Entry> fetch() {
    return _entries;
  }

  bool check(String entryId, String secret, OTPType type) {
    return _entries
        .where(
            (e) => e.secret == secret && e.type == type && e.entryId == entryId)
        .isNotEmpty;
  }

  Future reorder(Entry source, int from, int to) async {
    final Entry? destination = _entries[to];

    if (destination != null) {
      _entries.removeAt(from);
      _entries.insert(to, source);

      await _box.clear();
      await _box.addAll(_entries);
    }
  }
}
