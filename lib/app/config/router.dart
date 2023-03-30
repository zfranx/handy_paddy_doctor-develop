import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../views/screens/analysis/pages.dart';
import '../../views/screens/home/pages.dart';
import '../../views/screens/onboarding/pages.dart';
import '../utils/router_utils.dart';

class Routes {
  static Route<dynamic> generateRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case RouterUtils.onboardingScreen:
        return MaterialPageRoute(builder: (_) => OnboardingScreen());
      case RouterUtils.homeScreen:
        return MaterialPageRoute(builder: (_) => HomeScreen(), settings: routeSettings);
      case RouterUtils.analysisScreen:
        return MaterialPageRoute(builder: (_) => AnalysisScreen(),  settings: routeSettings);
      default:
        return MaterialPageRoute(builder: (_) => HomeScreen());
    }
  }
}