import 'package:flutter/material.dart';
import 'package:nanny_components/nanny_components.dart';
import 'package:nanny_core/nanny_core.dart';
import 'package:nanny_driver/globals.dart';
import 'package:nanny_driver/views/reg_pages/step_six.dart';

class RegStepFiveVM extends ViewModelBase {
  RegStepFiveVM({
    required super.context, 
    required super.update,
  });

  DriverUserData regForm = NannyDriverGlobals.driverRegForm;

  GlobalKey<FormState> answer1State = GlobalKey();
  GlobalKey<FormState> answer2State = GlobalKey();

  String answer1 = "";
  String answer2 = "";

  void nextStep() {
    if(!answer1State.currentState!.validate() ||
       !answer2State.currentState!.validate()
    ) return;

    regForm.driverData = regForm.driverData.copyWith(
      answers: Answers(
        first: answer1,
        second: answer2,
      ),
    );

    slideNavigateToView(const RegStepSixView());
  }
}