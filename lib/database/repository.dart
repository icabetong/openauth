import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
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
    final lastEntry = getLastInPosition(entries.toList());

    entry.position = lastEntry == null ? 0 : lastEntry.position + 1;
    return await box.put(entry.entryId, entry);
  }

  @override
  Future remove(Entry data) async {
    return await box.delete(data.entryId);
  }

  @override
  List<Entry> fetch({generate = false}) {
    return List.castFrom(box.values.toList());
  }

  bool check(String entryId, String secret, OTPType type) {
    return box.values
        .where(
            (e) => e.secret == secret && e.type == type && e.entryId == entryId)
        .isNotEmpty;
  }

  Future reorder(Entry source, int from, int to) async {
    final destination = box.getAt(to)?.copyWith();
    final affected = to > from
        ? box.values
            .where((entry) => entry.position > from && entry.position < to)
        : box.values
            .where((entry) => entry.position < from && entry.position > to);

    if (destination != null) {
      source.position = to;
      // from bottom to top
      if (from > to) {
        destination.position = to + 1;
        for (var entry in affected) {
          if (entry.entryId != source.entryId &&
              entry.entryId != destination.entryId) {
            entry.position = to + 2;
          }
        }
      } else if (to > from) {
        destination.position = to - 1;
        for (var entry in affected) {
          if (entry.entryId != source.entryId &&
              entry.entryId != destination.entryId) {
            entry.position = to - 2;
          }
        }
      }

      await box.put(source.entryId, source);
      await box.put(destination.entryId, destination);
      debugPrint('${source.name}:${source.position}');
      debugPrint(destination.position.toString());
      for (var entry in affected) {
        await box.put(entry.entryId, entry);
      }
    }
  }

  static swap(Box<Entry> box, Entry source, int from, int to) async {
    final destination = box.getAt(to)?.copyWith();
    final affected = to > from
        ? box.values
            .where((entry) => entry.position > from && entry.position < to)
        : box.values
            .where((entry) => entry.position < from && entry.position > to);

    if (destination != null) {
      source.position = to;
      // from bottom to top
      if (from > to) {
        destination.position = to + 1;
        for (var entry in affected) {
          if (entry.entryId != source.entryId &&
              entry.entryId != destination.entryId) {
            entry.position = to + 2;
          }
        }
      } else if (to > from) {
        destination.position = to - 1;
        for (var entry in affected) {
          if (entry.entryId != source.entryId &&
              entry.entryId != destination.entryId) {
            entry.position = to - 2;
          }
        }
      }

      await box.put(source.entryId, source);
      await box.put(destination.entryId, destination);
      debugPrint('${source.name}:${source.position}');
      debugPrint(destination.position.toString());
      for (var entry in affected) {
        await box.put(entry.entryId, entry);
      }
    }
  }

  ValueListenable<Box<Entry>> listen() {
    return box.listenable();
  }
}
