import 'dart:typed_data';
import 'package:hive_flutter/adapters.dart';
part 'analysis_model.g.dart';

@HiveType(typeId: 0)
class AnalysisModel extends HiveObject {
  @HiveField(0)
  late Uint8List? image;

  @HiveField(1)
  late List<dynamic>? outputs;

  AnalysisModel({
    this.image,
    this.outputs
  });

  AnalysisModel.fromJson(Map<String, dynamic> json) {
    image = json['image'];
    outputs = json['output'];
  }

  AnalysisModel copyWith({
    Uint8List? image,
    required List<dynamic> outputs
  }) {
    return AnalysisModel(
      image: image ?? this.image,
      outputs: outputs ?? this.outputs
    );
  }
}
