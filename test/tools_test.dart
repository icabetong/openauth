import 'package:flutter_test/flutter_test.dart';
import 'package:openauth/entry/entry.dart';
import 'package:openauth/shared/tools.dart';

void main() {
  test('Check if last position correctly being returned', () {
    final entries = [
      Entry('AA', 'AA', 'AA', position: 1),
      Entry('BB', 'BB', 'BB', position: 2),
      Entry('CC', 'CC', 'CC', position: 0)
    ];

    Entry? entry = getLastInPosition(entries);
    expect(entry!.secret, equals('BB'));
  });

  test('Test swap', () {
    const from = 5;
    const to = 2;
    final entries = [
      Entry('AA', 'AA', 'AA', position: 0),
      Entry('BB', 'BB', 'BB', position: 1),
      Entry('CC', 'CC', 'CC', position: 2),
      Entry('DD', 'DD', 'DD', position: 3),
      Entry('EE', 'EE', 'EE', position: 4),
      Entry('FF', 'FF', 'FF', position: 5),
      Entry('GG', 'GG', 'GG', position: 6),
    ];

    final source = entries[from].copyWith();
    final destination = entries[to].copyWith();
    final affected = to > from
        ? entries.where((e) => e.position > from && e.position < to)
        : entries.where((e) => e.position < from && e.position > to);

    source.position = to;
    // from bottom to top
    if (from > to) {
      destination.position += 1;
      for (var entry in affected) {
        entry.position++;
      }
    } else if (from < to) {
      destination.position -= 1;
      for (var entry in affected) {
        entry.position--;
      }
    }

    expect(source.position, equals(to));
    expect(destination.position, equals(3));
  });
}
