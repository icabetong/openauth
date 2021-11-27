import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:openauth/entry/entry.dart';
import 'package:openauth/database/repository.dart';
import 'package:openauth/settings/provider.dart';

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

  ValueListenable<Box<Entry>> listen() {
    return repository.listen();
  }

  bool check(String entryId, String secret, OTPType type) {
    return repository.check(entryId, secret, type);
  }

  void sort(Sort sort) {
    switch (sort) {
      case Sort.custom:
        _entries
            .sort((current, next) => current.position.compareTo(next.position));
        break;
      case Sort.nameAscending:
        _entries.sort((current, next) => current.name.compareTo(next.name));
        break;
      case Sort.nameDescending:
        _entries.sort((current, next) => current.name.compareTo(next.name));
        break;
      case Sort.issuerAscending:
        _entries.sort((current, next) => current.name.compareTo(next.name));
        break;
      case Sort.issuerDescending:
        _entries.sort((current, next) => current.name.compareTo(next.name));
        break;
    }
    notifyListeners();
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
    _entries.sort((current, next) => current.position.compareTo(next.position));
    //debugPrint(_entries.map((e) => '${e.name}:${e.position}').toString());
    notifyListeners();
    return result;
  }
}
