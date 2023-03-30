
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:onboarding/onboarding.dart';

import '../../../app/config/themes.dart';

List<PageModel> OnboardingPages = [
  PageModel(
    widget: DecoratedBox(
      decoration: BoxDecoration(
        color: ThemeColors.darkYellowAccent,
        border: Border.all(
          width: 0.0,
          color: ThemeColors.darkYellowAccent
        ),
      ),
      child: SingleChildScrollView(
        controller: ScrollController(),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 45.0,
                  vertical: 90.0
              ),
              child: Image.asset(
                'assets/images/logo.png',
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 45.0),
              child: Text(
                'Agrease',
                style: pageTitleStyle
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 45.0, vertical: 20.0),
              child: Text(
                'Agrease is a mobile application that helps farmers to diagnose their paddy diseases and get the right treatment for it.',
                style: pageInfoStyle,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        )
      ),
    )
  ),
  PageModel(
    widget: DecoratedBox(
      decoration: BoxDecoration(
        color: ThemeColors.darkYellowAccent,
        border: Border.all(
          width: 0.0,
          color: ThemeColors.darkYellowAccent
        ),
      ),
      child: SingleChildScrollView(
        controller: ScrollController(),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 45.0,
                  vertical: 90.0
              ),
              child: Image.asset(
                'assets/images/logo.png',
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 45.0),
              child: Text(
                'Diagnose your plants',
                style: pageTitleStyle
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 45.0, vertical: 20.0),
              child: Text(
                'Agrease is a mobile application that helps farmers to diagnose their paddy diseases and get the right treatment for it.',
                style: pageInfoStyle,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        )
      ),
    )
  ),
  PageModel(
    widget: DecoratedBox(
      decoration: BoxDecoration(
        color: ThemeColors.darkYellowAccent,
        border: Border.all(
          width: 0.0,
          color: ThemeColors.darkYellowAccent
        ),
      ),
      child: SingleChildScrollView(
        controller: ScrollController(),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 45.0,
                  vertical: 90.0
              ),
              child: Image.asset(
                'assets/images/logo.png',
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 45.0),
              child: Text(
                'Get the best treatment',
                style: pageTitleStyle
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 45.0, vertical: 20.0),
              child: Text(
                'Agrease is a mobile application that helps farmers to get the best treatment for their paddy diseases.',
                style: pageInfoStyle,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        )
      ),
    )
  ),
];