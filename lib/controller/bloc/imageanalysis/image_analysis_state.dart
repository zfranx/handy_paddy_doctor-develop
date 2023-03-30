part of 'image_analysis_bloc.dart';

abstract class ImageAnalysisState extends Equatable {
  const ImageAnalysisState();

  @override
  List<Object> get props => [];
}

class ImageAnalysisInitial extends ImageAnalysisState {}

class ImageAnalysisLoading extends ImageAnalysisState {}

class ImageAnalysisSuccess extends ImageAnalysisState {
  final List<dynamic> outputs;

  const ImageAnalysisSuccess(this.outputs);

  @override
  List<Object> get props => [outputs];

  @override
  String toString() => 'ImageAnalysisSuccess { outputs: $outputs }';
}

class ImageAnalysisFailure extends ImageAnalysisState {
  final String error;

  const ImageAnalysisFailure(this.error);

  @override
  List<Object> get props => [error];

  @override
  String toString() => 'ImageAnalysisFailure { error: $error }';
}