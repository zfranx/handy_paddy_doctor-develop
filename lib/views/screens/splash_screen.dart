import 'package:flutter/material.dart';

import '../../app/config/themes.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: ThemeColors.darkYellow,
        child: Center(
          child: Image.asset('assets/images/logo.png',),
        ),
      ),
    );
  }
}
