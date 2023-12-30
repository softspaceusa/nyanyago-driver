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
      imgPath: "imgPath", 
      paths: NannyConsts.availablePaths
    ),
  );
}