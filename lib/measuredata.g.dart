// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'measuredata.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MeasureDataAdapter extends TypeAdapter<MeasureData> {
  @override
  final int typeId = 1;

  @override
  MeasureData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MeasureData(
      fields[0] as String,
      fields[1] as int,
      fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, MeasureData obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.measureTiming)
      ..writeByte(1)
      ..write(obj.bg)
      ..writeByte(2)
      ..write(obj.tag);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MeasureDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class MeasureDataListAdapter extends TypeAdapter<MeasureDataList> {
  @override
  final int typeId = 2;

  @override
  MeasureDataList read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MeasureDataList()
      ..dataList = (fields[0] as List)?.cast<MeasureData>();
  }

  @override
  void write(BinaryWriter writer, MeasureDataList obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.dataList);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MeasureDataListAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
