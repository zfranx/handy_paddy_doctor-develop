import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:handy_paddy_doctor/app/utils/arguments.dart';
import 'package:handy_paddy_doctor/controller/bloc/home/home_bloc.dart';
import 'package:handy_paddy_doctor/controller/bloc/imagepicker/image_picker_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:handy_paddy_doctor/views/screens/home/components.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

import '../../../app/utils/router_utils.dart';
import '../component/common_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  HomeBloc homeBloc = HomeBloc();
  ImagePickerBloc imagePickerBloc = ImagePickerBloc();
  RouterArguments arguments = RouterArguments();
  Function(ImageSource)? onPickDialogFinish;
  int? onboardingPrefs;
  List<TargetFocus> targets = [];
  final cameraKey = GlobalKey();
  final cameraAppBarKey = GlobalKey();
  late final tempDir;


  @override
  void initState() {
    targetInit();
    super.initState();
    homeBloc.add(HomeFetch());
    onPickDialogFinish = (ImageSource source) {
      imagePickerBloc.add(ImagePickerStarted(source));
    };
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      tempDir = await getTemporaryDirectory();
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args != null) {
        arguments = args as RouterArguments;
        if (arguments.onboardingPrefs != null) {
          onboardingPrefs = arguments.onboardingPrefs;
          showTutorial();
        }
      }
    });
  }

  @override
  void dispose() {
    homeBloc.close();
    imagePickerBloc.close();
    super.dispose();
  }

  void targetInit() {
    targets.add(
      TargetFocus(
        identify: "Target 1",
        keyTarget: cameraKey,
        contents: [
          TargetContent(
            align: ContentAlign.top,
            child: Container(
              child:Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    "Ambil gambar/foto tanaman anda",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 20.0
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10.0),
                    child: Text("Ambil gambar dari tanaman anda yang ada di galeri ataupun dengan foto melalui kamera.",
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
    targets.add(
      TargetFocus(
        identify: "Target 2",
        keyTarget: cameraAppBarKey,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            child: Container(
              child:Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    "Kamu bisa juga mengambil foto atau gambar dengan menekan gambar kamera diatas",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                    ),
                  ),
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

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<HomeBloc>(create: (context) => homeBloc),
        BlocProvider<ImagePickerBloc>(create: (context) => imagePickerBloc),
      ],
      child: BlocListener<ImagePickerBloc, ImagePickerState>(
        listener: (context, state) {
          if (state is ImagePickerSuccess) {
            if (onboardingPrefs != null) {
              arguments = RouterArguments(
                imagePath: state.imagePath,
                onboardingPrefs: onboardingPrefs,
              );
              Navigator.pushNamed(context, RouterUtils.analysisScreen, arguments: arguments).then(
                (data) {
                  if (data != null && data == true) {
                    homeBloc.add(HomeFetch());
                  }
                }
              );
            } else {
              arguments = RouterArguments(
                imagePath: state.imagePath,
              );
              Navigator.pushNamed(context, RouterUtils.analysisScreen, arguments: arguments).then(
                      (data) {
                    if (data != null && data == true) {
                      homeBloc.add(HomeFetch());
                    }
                  }
              );
            }
          }
        },
        child: Scaffold(
          floatingActionButton: HomeFloatingActionButton(
            key: cameraKey,
            onPressed: () {
              imagePickingDialog(
                context: context,
                onDialogFinish: onPickDialogFinish!,
              );
            },
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
          appBar: HomeAppBar(
            cameraAppBarKey: cameraAppBarKey,
            onMenuPressed: () { },
            onSearchPressed: () {
              imagePickingDialog(
                context: context,
                onDialogFinish: onPickDialogFinish!,
              );
            },
          ),
          extendBody: true,
          bottomNavigationBar: BottomAppBar(
            clipBehavior: Clip.antiAlias,
            shape: const CircularNotchedRectangle(),
            color: Theme.of(context).primaryColor.withAlpha(255),
            elevation: 0,
            child: HomeBottomNavigationBar(
              onItemTapped: (selectedItem) {

              },
            ),
          ),
          body: BlocBuilder<HomeBloc, HomeState>(
            builder: (context, state) {
              if (state is HomeLoading) {
                return ListView.builder(
                  itemCount: 3,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                      child: Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                        child: Container(
                          height: 200,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                      ),
                    );
                  },
                );
              } else if (state is HomeLoaded) {
                return ListView.builder(
                  reverse: true,
                  shrinkWrap: true,
                  itemCount: state.recentImages.length,
                  itemBuilder: (context, index) {
                    return RecentImagesListItem(
                      analysis: state.recentImages[index],
                      onItemPressed: () {
                        File tempFile = File("${tempDir.path}/temp.png}");
                        tempFile.writeAsBytes(state.recentImages[index].image!).then((value) {
                          arguments = RouterArguments(
                            imagePath: tempFile.path,
                          );
                          Navigator.pushNamed(context, RouterUtils.analysisScreen, arguments: arguments).then(
                                  (data) {
                                if (data != null && data == true) {
                                  homeBloc.add(HomeFetch());
                                }
                              }
                          );
                        });
                      },
                    );
                  },
                );
              } else {
                return const Center(
                  child: Text('Something went wrong'),
                );
              }
            },
          ),
        ),
      ),
    );
  }


}
