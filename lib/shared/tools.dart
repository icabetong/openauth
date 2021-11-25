import 'dart:math';

import 'package:openauth/entry/entry.dart';

String randomId() {
  final random = Random();
  const idLength = 20;
  const characters =
      "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";

  String id = "";
  for (int i = 0; i < idLength; i++) {
    id += characters[random.nextInt(characters.length)];
  }
  assert(id.length == idLength);
  return id;
}

List<Entry> swap(List<Entry> base, Entry data, int newIndex, int oldIndex) {
  base.removeAt(oldIndex);
  base.insert(newIndex, data);

  List<Entry> _entries = [];
  for (int i = 0; i < base.length; i++) {
    final entry = base[i];
    entry.position = i;
    _entries.insert(i, entry);
  }
  return _entries;
}
