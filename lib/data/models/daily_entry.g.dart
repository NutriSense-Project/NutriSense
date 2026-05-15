// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'daily_entry.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DailyEntryAdapter extends TypeAdapter<DailyEntry> {
  @override
  final int typeId = 1;

  @override
  DailyEntry read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DailyEntry(
      id: fields[0] as String,
      date: fields[1] as DateTime,
      servings: (fields[2] as Map).cast<String, int>(),
      score: fields[3] as int,
    );
  }

  @override
  void write(BinaryWriter writer, DailyEntry obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.date)
      ..writeByte(2)
      ..write(obj.servings)
      ..writeByte(3)
      ..write(obj.score);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DailyEntryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
