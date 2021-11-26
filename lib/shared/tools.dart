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
  return id;
}

Entry? getLastInPosition(List<Entry> entries) {
  return entries.isEmpty
      ? null
      : entries
          .reduce((curr, next) => curr.position > next.position ? curr : next);
}
