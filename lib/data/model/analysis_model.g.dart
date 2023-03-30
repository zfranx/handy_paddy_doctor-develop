// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'analysis_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AnalysisModelAdapter extends TypeAdapter<AnalysisModel> {
  @override
  final int typeId = 0;

  @override
  AnalysisModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AnalysisModel(
      image: fields[0] as Uint8List?,
      outputs: (fields[1] as List?)?.cast<dynamic>(),
    );
  }

  @override
  void write(BinaryWriter writer, AnalysisModel obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.image)
      ..writeByte(1)
      ..write(obj.outputs);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AnalysisModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
