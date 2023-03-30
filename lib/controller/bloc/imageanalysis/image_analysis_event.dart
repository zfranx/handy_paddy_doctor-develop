part of 'image_analysis_bloc.dart';

abstract class ImageAnalysisEvent extends Equatable {
  const ImageAnalysisEvent();

  @override
  List<Object> get props => [];
}

class ImageAnalysisStarted extends ImageAnalysisEvent {
  final String imagePath;

  const ImageAnalysisStarted(this.imagePath);

  @override
  List<Object> get props => [imagePath];

  @override
  String toString() => 'ImageAnalysisStarted { imagePath: $imagePath }';
}

class ImageAnalysisReset extends ImageAnalysisEvent {}