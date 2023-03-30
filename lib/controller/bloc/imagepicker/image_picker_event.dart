part of 'image_picker_bloc.dart';

abstract class ImagePickerEvent extends Equatable {
  const ImagePickerEvent();

  @override
  List<Object> get props => [];
}

class ImagePickerStarted extends ImagePickerEvent {
  final ImageSource imageSource;

  const ImagePickerStarted(this.imageSource);

  @override
  List<Object> get props => [imageSource];

  @override
  String toString() => 'ImagePickerStarted { imageSource: $imageSource }';
}

class ImagePickerPicked extends ImagePickerEvent {
  final String imagePath;

  const ImagePickerPicked(this.imagePath);

  @override
  List<Object> get props => [imagePath];

  @override
  String toString() => 'ImagePickerPicked { image: $imagePath }';
}

class ImagePickerCanceled extends ImagePickerEvent {}

class ImagePickerError extends ImagePickerEvent {
  final String error;

  const ImagePickerError(this.error);

  @override
  List<Object> get props => [error];

  @override
  String toString() => 'ImagePickerError { error: $error }';
}