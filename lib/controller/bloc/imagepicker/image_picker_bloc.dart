import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

part 'image_picker_event.dart';
part 'image_picker_state.dart';

class ImagePickerBloc extends Bloc<ImagePickerEvent, ImagePickerState> {
  ImagePickerBloc() : super(ImagePickerInitial()) {
    on<ImagePickerStarted>(_onImagePickerButtonPressed);
  }

  Future<void> _onImagePickerButtonPressed(ImagePickerStarted event, Emitter<ImagePickerState> emit) async {
    emit(ImagePickerLoading());
    try {
      final pickedImage = await ImagePicker().pickImage(source: event.imageSource);
      emit(ImagePickerSuccess(pickedImage!.path));
    } catch (e) {
      emit(ImagePickerFailure(e.toString()));
    }
  }
}