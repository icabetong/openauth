import 'package:flutter/cupertino.dart';
import 'package:openauth/core/entry.dart';
import 'package:openauth/database/repository.dart';

class EntryNotifier extends ChangeNotifier {
  final EntryRepository repository = EntryRepository();
  List<Entry> _entries = [];
  List<Entry> get entries => _entries;

  EntryNotifier() {
    _entries = repository.fetch();
  }

  Future put(Entry entry) async {
    await repository.put(entry);
    notifyListeners();
  }

  Future remove(Entry entry) async {
    await repository.put(entry);
    notifyListeners();
  }
}
