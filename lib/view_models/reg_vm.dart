import 'package:flutter/material.dart';
import 'package:nanny_components/nanny_components.dart';
import 'package:nanny_core/nanny_core.dart';
import 'package:nanny_driver/views/reg_pages.dart/step_one.dart';

class RegVM extends ViewModelBase {
  RegVM({
    required super.context, 
    required super.update,
  });

  Widget currentRegPage = const RegStepOneView();

  void navigateToLogin() => navigateToView(
    LoginView(
      imgPath: "packages/nanny_components/assets/images/Saly-10.png", 
      paths: NannyConsts.availablePaths
    ),
  );

  bool inited = false;
  final GlobalKey<NavigatorState> navKey = GlobalKey<NavigatorState>();

  Route<dynamic>? onRouteGen(RouteSettings settings) {
    if(!inited) return MaterialPageRoute(builder: (context) => const RegStepOneView());

    return null;
  }

  // void setupNavigator() => navKey.currentState?.push(
  //   MaterialPageRoute(builder: (context) => const RegStepOneView())
  // );
}