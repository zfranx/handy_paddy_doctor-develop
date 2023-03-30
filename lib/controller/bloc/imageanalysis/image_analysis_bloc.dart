
import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:handy_paddy_doctor/data/domain/analysis_domain.dart';
import 'package:tflite/tflite.dart';

import '../../../app/utils/tensorflow_utils.dart';
import '../../../data/model/analysis_model.dart';

part 'image_analysis_event.dart';
part 'image_analysis_state.dart';

class ImageAnalysisBloc extends Bloc<ImageAnalysisEvent, ImageAnalysisState> {
  ImageAnalysisBloc() : super(ImageAnalysisInitial()) {
    on<ImageAnalysisStarted>(_onImageAnalysisStarted);
    on<ImageAnalysisReset>(_onImageAnalysisReset);
  }
  final AnalysisDomain _analysisDomain = AnalysisDomain();

  Future<void> _onImageAnalysisStarted(ImageAnalysisStarted event, Emitter<ImageAnalysisState> emit) async {
    emit(ImageAnalysisLoading());
    try {
      await Tflite.loadModel(
        model: TensorflowUtils.model,
        labels: TensorflowUtils.labels,
      );
      var outputs = await Tflite.runModelOnImage(
        path: event.imagePath,
        numResults: 2,
        threshold: 0.0005,
        imageMean: 127.5,
        imageStd: 127.5,
        asynch: true,
      );
      AnalysisModel analysis = AnalysisModel(
        image: await File(event.imagePath).readAsBytes(),
        outputs: outputs,
      );
      _analysisDomain.createAnalysis(analysis);
      emit(ImageAnalysisSuccess(outputs!));
      await Tflite.close();
    } catch (e) {
      emit(ImageAnalysisFailure(e.toString()));
    }
  }

  void _onImageAnalysisReset(ImageAnalysisReset event, Emitter<ImageAnalysisState> emit) {
    emit(ImageAnalysisInitial());
  }

}