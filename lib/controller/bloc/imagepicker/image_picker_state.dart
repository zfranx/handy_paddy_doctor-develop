part of 'image_picker_bloc.dart';

abstract class ImagePickerState extends Equatable {
  const ImagePickerState();

  @override
  List<Object> get props => [];
}

class ImagePickerInitial extends ImagePickerState {}

class ImagePickerLoading extends ImagePickerState {}

class ImagePickerSuccess extends ImagePickerState {
  final String imagePath;

  const ImagePickerSuccess(this.imagePath);

  @override
  List<Object> get props => [imagePath];

  @override
  String toString() => 'ImagePickerSuccess { imagePath: $imagePath }';
}

class ImagePickerFailure extends ImagePickerState {
  final String error;

  const ImagePickerFailure(this.error);

  @override
  List<Object> get props => [error];

  @override
  String toString() => 'ImagePickerFailure { error: $error }';
}