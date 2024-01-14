import 'package:flutter/material.dart';
import 'package:nanny_components/nanny_components.dart';
import 'package:nanny_core/api/api_models/driver_user_request.dart';
import 'package:nanny_driver/globals.dart';
import 'package:nanny_driver/views/reg_pages.dart/step_eight.dart';

class RegStepSevenVM extends ViewModelBase {
  RegStepSevenVM(
    {required super.context,
    required super.update,
  });

  DriverUserData regForm = NannyDriverGlobals.driverRegForm;

  GlobalKey<FormState> answer5State = GlobalKey();
  GlobalKey<FormState> answer6State = GlobalKey();

  String answer5 = "";
  String answer6 = "";

  void nextStep() {
    if(!answer5State.currentState!.validate() ||
       !answer6State.currentState!.validate()
    ) return;

    regForm.driverData = regForm.driverData.copyWith(
      answers: regForm.driverData.answers!.copyWith(
        fifth: answer5,
        sixth: answer6,
      ),
    );

    slideNavigateToView(const RegStepEightView());
  }
}