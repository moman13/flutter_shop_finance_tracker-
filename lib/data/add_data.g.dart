// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'add_data.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AdddateAdapter extends TypeAdapter<Add_date> {
  @override
  final int typeId = 1;

  @override
  Add_date read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Add_date(
      fields[3] as String,
      fields[1] as String,
      fields[2] as String,
      fields[0] as String,
      fields[4] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, Add_date obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.note)
      ..writeByte(1)
      ..write(obj.explain)
      ..writeByte(2)
      ..write(obj.amount)
      ..writeByte(3)
      ..write(obj.paymentType)
      ..writeByte(4)
      ..write(obj.datetime);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AdddateAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
