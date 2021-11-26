import 'package:flutter/foundation.dart';
import 'package:openauth/entry/entry.dart';
import 'package:openauth/database/repository.dart';

class EntryNotifier extends ChangeNotifier {
  final EntryRepository repository = EntryRepository();
  List<Entry> _entries = [];
  List<Entry> get entries {
    _entries.sort((current, next) => current.position.compareTo(next.position));
    return _entries;
  }

  EntryNotifier() {
    _entries = repository.fetch();
  }

  bool check(String entryId, String secret, OTPType type) {
    return repository.check(entryId, secret, type);
  }

  Future put(Entry entry) async {
    final result = await repository.put(entry);
    _entries = repository.fetch();
    notifyListeners();
    return result;
  }

  Future remove(Entry entry) async {
    final result = await repository.remove(entry);
    _entries = repository.fetch();
    notifyListeners();
    return result;
  }

  Future<bool?> reorder(Entry entry, int from, int to) async {
    final result = await repository.reorder(entry, from, to);
    _entries = repository.fetch();
    notifyListeners();
    return result;
  }
}
