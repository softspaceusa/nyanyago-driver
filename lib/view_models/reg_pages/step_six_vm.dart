import 'package:flutter/material.dart';
import 'package:nanny_components/nanny_components.dart';
import 'package:nanny_driver/globals.dart';
import 'package:nanny_driver/views/reg_pages.dart/step_seven.dart';

class RegStepSixVM extends ViewModelBase {
  RegStepSixVM(
    {required super.context,
    required super.update,
  });

  DriverRegData regForm = NannyDriverGlobals.driverRegForm;

  GlobalKey<FormState> answer3State = GlobalKey();
  GlobalKey<FormState> answer4State = GlobalKey();

  String answer3 = "";
  String answer4 = "";

  void nextStep() {
    if(!answer3State.currentState!.validate() ||
       !answer4State.currentState!.validate()
    ) return;

    regForm.driverData = regForm.driverData.copyWith(
      answers: regForm.driverData.answers!.copyWith(
        third: answer3,
        fourth: answer4,
      ),
    );

    slideNavigateToView(const RegStepSevenView());
  }
}