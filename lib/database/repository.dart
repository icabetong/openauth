import 'package:hive/hive.dart';
import 'package:openauth/entry/entry.dart';
import 'package:openauth/shared/tools.dart';

abstract class Repository<T> {
  Future put(T data);
  Future remove(T data);
  List<T> fetch();
}

class EntryRepository extends Repository<Entry> {
  static const _boxName = "entries";
  final box = Hive.box<Entry>(_boxName);

  static Future<bool> open(key) async {
    if (!Hive.isBoxOpen(_boxName)) {
      await Hive.openBox<Entry>(_boxName, encryptionCipher: HiveAesCipher(key));
    }
    return true;
  }

  @override
  Future put(Entry data) async {
    final entries = box.values;
    final entry = data;
    final lastEntry = entries.isEmpty
        ? null
        : box.values.reduce((current, next) =>
            current.position > next.position ? current : next);

    entry.position = lastEntry == null ? 1 : lastEntry.position + 1;
    return await box.put(entry.entryId, entry);
  }

  @override
  Future remove(Entry data) async {
    return await box.delete(data.entryId);
  }

  @override
  List<Entry> fetch() {
    return List.castFrom(box.values.toList());
  }

  bool check(String entryId, String secret, OTPType type) {
    return box.values
        .where(
            (e) => e.secret == secret && e.type == type && e.entryId == entryId)
        .isNotEmpty;
  }

  void reorder(Entry entry, int newIndex, int oldIndex) {
    final entries = swap(box.values.toList(), entry, newIndex, oldIndex);
    box.addAll(entries);
  }
}
