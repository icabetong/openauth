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

  Future reorder(Entry entry, int from, int to) async {
    final source = box.getAt(from);
    final destination = box.getAt(to);
    final affected = to > from
        ? box.values
            .where((entry) => entry.position > from && entry.position < to)
        : box.values
            .where((entry) => entry.position < from && entry.position > to);

    if (source != null && destination != null) {
      source.position = to;
      // from bottom to top
      if (from > to) {
        destination.position += 1;
        for (var entry in affected) {
          entry.position++;
        }
      } else {
        destination.position -= 1;
        for (var entry in affected) {
          entry.position--;
        }
      }

      await box.put(source.entryId, source);
      await box.put(destination.entryId, destination);
      for (var entry in affected) {
        await box.put(entry.entryId, entry);
      }
    }
  }
}
