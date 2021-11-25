import 'package:flutter_test/flutter_test.dart';
import 'package:openauth/entry/entry.dart';
import 'package:openauth/shared/tools.dart';

void main() {
  final List<Entry> entries = [
    Entry('XX', 'Test', '0', position: 0),
    Entry('AA', 'Test', '1', position: 1),
    Entry('BB', 'Test', '2', position: 2),
    Entry('CC', 'Test', '3', position: 3),
    Entry('DD', 'Test', '4', position: 4),
    Entry('EE', 'Test', '5', position: 5),
    Entry('FF', 'Test', '6', position: 6),
  ];

  group('Reorder items-move from bottom to top', () {
    test('Check if the item swapped using its secret attribute', () {
      final _entries = swap([...entries], entries[5], 2, 5);
      expect(_entries[2].secret, equals('EE'));
    });

    test('Check if the provided entry has its position changed', () {
      final _entries = swap([...entries], entries[5], 2, 5);
      expect(_entries[2].position, equals(2));
    });

    test('Check if items outside the swapping scope is unaffected', () {
      final _entries = swap([...entries], entries[5], 2, 5);
      expect(_entries[6].secret, equals('FF'));
      expect(_entries[1].secret, equals('AA'));
    });

    test('Check if swapped items are in their correct positions', () {
      final _entries = swap([...entries], entries[5], 2, 5);
      expect(_entries[3].secret, equals('BB'));
      expect(_entries[4].secret, equals('CC'));
      expect(_entries[5].secret, equals('DD'));
    });

    test('Check if swapped items has their value position decremented', () {
      final _entries = swap([...entries], entries[5], 2, 5);
      expect(_entries[3].position, equals(3));
      expect(_entries[4].position, equals(4));
      expect(_entries[5].position, equals(5));
    });
  });

  group('Reorder items-move from top to bottom', () {
    test('Check if the item swapped using its secret attribute', () {
      final _entries = swap([...entries], entries[2], 5, 2);
      expect(_entries[5].secret, equals('BB'));
    });

    test('Check if the provided entry has its rowPosition changed', () {
      final _entries = swap([...entries], entries[2], 5, 2);
      expect(_entries[5].position, equals(5));
    });

    test('Check if items outside the swapping scope is unaffected', () {
      final _entries = swap([...entries], entries[2], 5, 2);
      expect(_entries[6].secret, equals('FF'));
      expect(_entries[1].secret, equals('AA'));
    });

    test('Check if swapped items are in their correct positions', () {
      final _entries = swap([...entries], entries[2], 5, 2);
      expect(_entries[2].secret, equals('CC'));
      expect(_entries[3].secret, equals('DD'));
      expect(_entries[4].secret, equals('EE'));
    });

    test('Check if swapped items has their value position decremented', () {
      final _entries = swap([...entries], entries[2], 5, 2);
      expect(_entries[2].position, equals(2));
      expect(_entries[3].position, equals(3));
      expect(_entries[4].position, equals(4));
    });
  });
}
