import 'dart:math';

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
