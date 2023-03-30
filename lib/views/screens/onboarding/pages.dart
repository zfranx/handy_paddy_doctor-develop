import 'package:flutter/material.dart';
import 'package:handy_paddy_doctor/app/utils/arguments.dart';
import 'package:handy_paddy_doctor/views/screens/onboarding/components.dart';
import 'package:onboarding/onboarding.dart';

import '../../../app/config/themes.dart';
import '../../../app/utils/router_utils.dart';

class OnboardingScreen extends StatelessWidget {
  int index = 0;
  int onboardingPrefs = 0;
  RouterArguments arguments = RouterArguments();

  Material _skipButton(BuildContext context, {void Function(int)? setIndex}) {
    return Material(
      borderRadius: defaultSkipButtonBorderRadius,
      color: ThemeColors.darkYellow,
      child: InkWell(
        borderRadius: defaultSkipButtonBorderRadius,
        onTap: () {
          if (setIndex != null) {
            index = 2;
            setIndex(2);
          }
          arguments = RouterArguments(onboardingPrefs: onboardingPrefs);
          Navigator.pushNamed(context, RouterUtils.homeScreen, arguments: arguments);
        },
        child: const Padding(
          padding: defaultSkipButtonPadding,
          child: Text(
            'Skip',
            style: defaultSkipButtonTextStyle,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Onboarding(
        pages: OnboardingPages,
        onPageChange: (int pageIndex) {
          index = pageIndex;
        },
        startPageIndex: 0,
        footerBuilder: (context, dragDistance, pagesLength, setIndex) {
          return DecoratedBox(
            decoration: BoxDecoration(
              color: ThemeColors.darkYellowAccent,
              border: Border.all(
                width: 0.0,
                color: ThemeColors.darkYellowAccent
              ),
            ),
            child: ColoredBox(
              color: ThemeColors.darkYellowAccent,
              child: Padding(
                padding: const EdgeInsets.all(45.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomIndicator(
                      netDragPercent: dragDistance,
                      pagesLength: pagesLength,
                      indicator: Indicator(
                        indicatorDesign: IndicatorDesign.polygon(
                          polygonDesign: PolygonDesign(
                            polygon: DesignType.polygon_circle
                          )
                        )
                      ),
                    ),
                    _skipButton(context, setIndex: setIndex)
                  ]
                ),
              ),
            ),
          );
        }
      )
    );
  }
}
