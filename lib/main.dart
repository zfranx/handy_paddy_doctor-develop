import 'package:catcher/catcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:handy_paddy_doctor/app/config/app_config.dart';
import 'package:handy_paddy_doctor/views/screens/home/pages.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'app/config/router.dart';
import 'app/config/themes.dart';
import 'data/model/analysis_model.dart';

int? onboardingPrefs;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  onboardingPrefs = await prefs.getInt('onboarding');
  await prefs.setInt('onboarding', 1);
  await Hive.initFlutter();
  await Permission.storage.request();
  await Permission.camera.request();
  Hive.registerAdapter(AnalysisModelAdapter());

  if (AppConfig.ENABLE_LOGGING) {
    Bloc.observer = SimpleBlocObserver();
  }

  CatcherOptions debugOptions = CatcherOptions(SilentReportMode(), [
    ConsoleHandler(handleWhenRejected: true),
    ToastHandler(customMessage: "An Application error has occured"),
  ]);

  CatcherOptions releaseOptions = CatcherOptions(SilentReportMode(), [
    ToastHandler(customMessage: "An Application error has occured"),
  ]);
  Catcher(
    navigatorKey: GlobalKey<NavigatorState>(),
    rootWidget: MyApp(),
    debugConfig: debugOptions,
    ensureInitialized: true,
    releaseConfig: releaseOptions,
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: Catcher.navigatorKey,
      title: AppConfig.appName,
      onGenerateRoute: Routes.generateRoute,
      theme: ThemeData(
        backgroundColor: ThemeColors.darkYellowAccent,
        scaffoldBackgroundColor: ThemeColors.darkYellowAccent,
        indicatorColor: ThemeColors.darkYellow,
        appBarTheme: const AppBarTheme(
          backgroundColor: ThemeColors.darkYellow,
          elevation: 0,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            primary: ThemeColors.darkYellowAccent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: ThemeColors.darkYellow,
        ),
        primaryColor: ThemeColors.darkYellow,
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: onboardingPrefs == 0 || onboardingPrefs == null
          ? '/onboarding'
          : '/home',
    );
  }
}

class SimpleBlocObserver extends BlocObserver {
  @override
  void onEvent(Bloc? bloc, Object? event) {
    super.onEvent(bloc!, event);
    print('onEvent -- bloc: ${bloc.runtimeType}, event: $event');
  }

  @override
  void onTransition(Bloc? bloc, Transition? transition) {
    super.onTransition(bloc!, transition!);
    print('onTransition -- bloc: ${bloc.runtimeType}, transition: $transition');
  }

  @override
  void onError(BlocBase cubit, Object error, StackTrace stackTrace) {
    print('onError -- cubit: ${cubit.runtimeType}, error: $error');
    super.onError(cubit, error, stackTrace);
  }
}
