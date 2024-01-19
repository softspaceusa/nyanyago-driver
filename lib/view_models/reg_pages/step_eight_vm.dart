import 'package:flutter/material.dart';
import 'package:nanny_components/nanny_components.dart';
import 'package:nanny_core/nanny_core.dart';
import 'package:nanny_driver/globals.dart';
import 'package:nanny_driver/views/reg_pages.dart/reg_success.dart';

class RegStepEightVM extends ViewModelBase {
  RegStepEightVM({
    required super.context,
    required super.update,
  });

  DriverUserData regForm = NannyDriverGlobals.driverRegForm;

  GlobalKey<FormState> answer7State = GlobalKey();

  String answer7 = "";

  void nextStep() {
    if(!answer7State.currentState!.validate()) return;

    regForm.driverData = regForm.driverData.copyWith(
      answers: regForm.driverData.answers!.copyWith(
        seventh: answer7,
      ),
    );

    regForm.userData = regForm.userData.copyWith(
      phone: NannyGlobals.phone,
      // phone: "79370095967", // TODO: ОСТАРОЖНА
    );

    // slideNavigateToView(const PhoneConfirmView(
    //   nextScreen: RegSuccessView(), 
    //   title: "Подтверждение номера телефона", 
    //   text: "Введите код из СМС", 
    //   isReg: false,
    // )); 

    slideNavigateToView(const RegSuccessView());
  }
}