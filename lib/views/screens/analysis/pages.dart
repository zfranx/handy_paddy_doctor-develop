import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:handy_paddy_doctor/controller/bloc/imageanalysis/image_analysis_bloc.dart';
import 'package:handy_paddy_doctor/controller/bloc/imagepicker/image_picker_bloc.dart';
import 'package:handy_paddy_doctor/views/screens/component/common_widget.dart';
import 'package:image_picker/image_picker.dart';
import 'package:handy_paddy_doctor/views/screens/analysis/components.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

import '../../../app/config/themes.dart';
import '../../../app/utils/arguments.dart';

class AnalysisScreen extends StatefulWidget {
  const AnalysisScreen({Key? key}) : super(key: key);

  @override
  _AnalysisScreenState createState() => _AnalysisScreenState();
}

class _AnalysisScreenState extends State<AnalysisScreen> {
  ImagePickerBloc imagePickerBloc = ImagePickerBloc();
  ImageAnalysisBloc imageAnalysisBloc = ImageAnalysisBloc();
  Function(ImageSource)? onPickDialogFinish;
  bool isLoading = true;
  List<TargetFocus> targets = [];
  String _imagePath = '';
  final GlobalKey analysisKey = GlobalKey();

  @override
  void initState() {
    targetInit();
    super.initState();
    onPickDialogFinish = (ImageSource source) {
      imagePickerBloc.add(ImagePickerStarted(source));
    };
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final RouterArguments args = ModalRoute.of(context)?.settings.arguments as RouterArguments;
      setState(() {
        _imagePath = args.imagePath!;
        if (args.onboardingPrefs != null) {
          showTutorial();
        }
        isLoading = false;
      });
    });
  }

  @override
  void dispose() {
    imagePickerBloc.close();
    imageAnalysisBloc.close();
    super.dispose();
  }

  void targetInit() {
    targets.add(
      TargetFocus(
        identify: "Target 1",
        keyTarget: analysisKey,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            child: Container(
              child:Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    "Analisis gambar yang telah diambil",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 20.0
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10.0),
                    child: Text("Tekan tombol analisis untuk mendapatkan prediksi kesehatan tanaman anda",
                      style: TextStyle(
                          color: Colors.white
                      ),),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void showTutorial() {
    TutorialCoachMark(
      targets: targets,
      colorShadow: Colors.black,
      textSkip: "SKIP",
      paddingFocus: 10,
      opacityShadow: 0.8,
      onFinish: () {
        print("finish");
      },
      onClickTarget: (target) {
        print(target);
      },
      onClickOverlay: (target) {
        print(target);
      },
      onSkip: () {
        print("skip");
      },
    ).show(context: context);
  }

  void _showModalBottomSheet(BuildContext context, output) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return AnalysisModalBottomSheet(output: output);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider<ImagePickerBloc>(create: (context) => imagePickerBloc),
          BlocProvider<ImageAnalysisBloc>(create: (context) => imageAnalysisBloc),
        ],
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Analisis'),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
          ),
          body: BlocListener<ImagePickerBloc, ImagePickerState>(
            listener: (context, state) {
              if (state is ImagePickerSuccess) {
                imageAnalysisBloc.add(ImageAnalysisReset());
                setState(() {
                  _imagePath = state.imagePath;
                  isLoading = false;
                });
              }
            },
            child: Container (
              color: ThemeColors.darkYellowAccent,
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 25),
              child: Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: ThemeColors.darkYellow,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    Container(
                      height: 250,
                      width: 250,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: isLoading ? const Center(child: CircularProgressIndicator()) : Image.file(File(_imagePath), fit: BoxFit.cover),
                      ),
                    ),
                    const SizedBox(height: 20),
                    BlocBuilder<ImageAnalysisBloc, ImageAnalysisState>(
                      builder: (context, state) {
                        if (state is ImageAnalysisInitial) {
                          return Column(
                            children: [
                              ElevatedButton(
                                key: analysisKey,
                                onPressed: () {
                                  imageAnalysisBloc.add(ImageAnalysisStarted(_imagePath));
                                },
                                child: const Text('Analisis Gambar'),
                              ),
                            ],
                          );
                        }
                        else if (state is ImageAnalysisSuccess) {
                          return Column(
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  imagePickingDialog(
                                    context: context,
                                    onDialogFinish: onPickDialogFinish!,
                                  );
                                },
                                child: const Text('Ambil Gambar Lain'),
                              ),
                              const SizedBox(height: 10),
                              AnalysisResults(
                                outputs: state.outputs,
                                onAnalysisTapped: (output) {
                                  _showModalBottomSheet(context, output);
                                },
                              ),
                            ],
                          );
                        } else if (state is ImageAnalysisFailure) {
                          return Text('Analysis Error: ${state.error}');
                        } else {
                          return const CircularProgressIndicator();
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
    );
  }
}
