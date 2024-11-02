import 'package:flutter/material.dart';
import 'package:nanny_components/nanny_components.dart';
import 'package:nanny_core/nanny_core.dart';
import 'package:nanny_driver/views/reg_pages/step_five.dart';
import 'package:nanny_driver/views/reg_pages/step_four.dart';
import 'package:nanny_driver/views/reg_pages/step_one.dart';

import '../views/reg_pages/reg_success.dart';
import '../views/reg_pages/step_eight.dart';
import '../views/reg_pages/step_seven.dart';
import '../views/reg_pages/step_six.dart';
import '../views/reg_pages/step_three.dart';
import '../views/reg_pages/step_two.dart';

final regNavKey = GlobalKey<NavigatorState>();

class RegVM extends ViewModelBase {
  RegVM({
    required super.context,
    required super.update,
  });

  var currentIndex = 0;

  void navigateToLogin() => navigateToView(
        LoginView(
            imgPath: "packages/nanny_components/assets/images/Saly-10.png",
            paths: NannyConsts.availablePaths),
      );

  // bool inited = false;
  // final GlobalKey<NavigatorState> navKey = GlobalKey<NavigatorState>();
  void updatePage(int index) {}

  bool previousPage() {
    var navContext = regNavKey.currentContext;
    if (navContext == null) return false;
    Navigator.of(navContext).maybePop();
    return Navigator.of(navContext).canPop();
  }

  Route<dynamic>? onRouteGen(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(
            builder: (context) => RegStepOneView(updatePage));
      case 'step2':
        return MaterialPageRoute(builder: (context) => const RegStepTwoView());
      case 'step3':
        return MaterialPageRoute(
            builder: (context) => const RegStepThreeView());
      case 'step4':
        return MaterialPageRoute(builder: (context) => const RegStepFourView());
      case 'step5':
        return MaterialPageRoute(builder: (context) => const RegStepFiveView());
      case 'step6':
        return MaterialPageRoute(builder: (context) => const RegStepSixView());
      case 'step7':
        return MaterialPageRoute(
            builder: (context) => const RegStepSevenView());
      case 'step8':
        return MaterialPageRoute(
            builder: (context) => const RegStepEightView());
      case 'stepSuccess':
        return MaterialPageRoute(
            builder: (context) => const RegSuccessView());
      default:
        return null;
    }
    if (settings.name == '/') {
      return MaterialPageRoute(
          builder: (context) => RegStepOneView(updatePage));
    }

    return null;
  }

// void setupNavigator() => navKey.currentState?.push(
//   MaterialPageRoute(builder: (context) => const RegStepOneView())
// );
}
