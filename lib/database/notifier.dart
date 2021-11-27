import 'package:flutter/foundation.dart';
import 'package:openauth/entry/entry.dart';
import 'package:openauth/database/repository.dart';
import 'package:openauth/settings/provider.dart';

class EntryNotifier extends ChangeNotifier {
  final EntryRepository repository = EntryRepository();
  List<Entry> _entries = [];
  List<Entry> _origin = [];
  List<Entry> get entries => _entries;

  EntryNotifier() {
    _entries = repository.fetch();
    _origin = List.from(_entries);
  }

  bool check(String entryId, String secret, OTPType type) {
    return repository.check(entryId, secret, type);
  }

  void sort(Sort sort) {
    switch (sort) {
      case Sort.custom:
        _entries = _origin;
        break;
      case Sort.nameAscending:
        _entries.sort((curr, next) =>
            curr.name.toLowerCase().compareTo(next.name.toLowerCase()));
        break;
      case Sort.nameDescending:
        _entries.sort((curr, next) =>
            curr.name.toLowerCase().compareTo(next.name.toLowerCase()));
        _entries = _entries.reversed.toList();
        break;
      case Sort.issuerAscending:
        _entries.sort((curr, next) =>
            curr.issuer.toLowerCase().compareTo(next.issuer.toLowerCase()));
        break;
      case Sort.issuerDescending:
        _entries.sort((curr, next) =>
            curr.issuer.toLowerCase().compareTo(next.issuer.toLowerCase()));
        _entries = _entries.reversed.toList();
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
    notifyListeners();
    return result;
  }
}
