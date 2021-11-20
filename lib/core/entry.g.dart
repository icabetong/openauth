// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'entry.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class EntryAdapter extends TypeAdapter<Entry> {
  @override
  final int typeId = 0;

  @override
  Entry read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Entry(
      fields[1] as String,
      fields[2] as String,
      fields[3] as String,
      entryId: fields[0] as String,
      type: fields[7] as OTPType,
      length: fields[4] as int,
      period: fields[5] as int,
      counter: fields[6] as int,
      algorithm: fields[8] as String,
      isGoogle: fields[9] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, Entry obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.entryId)
      ..writeByte(1)
      ..write(obj.secret)
      ..writeByte(2)
      ..write(obj.issuer)
      ..writeByte(3)
      ..write(obj.name)
      ..writeByte(4)
      ..write(obj.length)
      ..writeByte(5)
      ..write(obj.period)
      ..writeByte(6)
      ..write(obj.counter)
      ..writeByte(7)
      ..write(obj.type)
      ..writeByte(8)
      ..write(obj.algorithm)
      ..writeByte(9)
      ..write(obj.isGoogle);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EntryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
