// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hub_page.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HubPageAdapter extends TypeAdapter<HubPage> {
  @override
  final int typeId = 1;

  @override
  HubPage read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HubPage(
      title: fields[1] as String,
      description: fields[2] as String,
      primaryLink: fields[3] as String,
      imagePath: fields[4] as String?,
      createdAt: fields[5] as DateTime,
    )..id = fields[0] as String;
  }

  @override
  void write(BinaryWriter writer, HubPage obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.primaryLink)
      ..writeByte(4)
      ..write(obj.imagePath)
      ..writeByte(5)
      ..write(obj.createdAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HubPageAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
