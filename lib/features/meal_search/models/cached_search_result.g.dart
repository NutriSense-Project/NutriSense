// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cached_search_result.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CachedSearchResultAdapter extends TypeAdapter<CachedSearchResult> {
  @override
  final int typeId = 2;

  @override
  CachedSearchResult read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CachedSearchResult(
      query: fields[0] as String,
      resultNames: (fields[1] as List).cast<String>(),
      timestamp: fields[2] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, CachedSearchResult obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.query)
      ..writeByte(1)
      ..write(obj.resultNames)
      ..writeByte(2)
      ..write(obj.timestamp);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CachedSearchResultAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
