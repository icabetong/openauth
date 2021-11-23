import 'package:flutter/foundation.dart';
import 'package:openauth/entry/entry.dart';
import 'package:openauth/database/repository.dart';

class EntryNotifier extends ChangeNotifier {
  final EntryRepository repository = EntryRepository();
  List<Entry> _entries = [];
  List<Entry> get entries => _entries;

  EntryNotifier() {
    _entries = repository.fetch();
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
}
