import 'dart:async';

import 'package:flutter/material.dart';
import 'package:nanny_components/nanny_components.dart';
import 'package:nanny_core/nanny_core.dart';
import 'package:nanny_driver/globals.dart';
import 'package:nanny_driver/views/reg_pages.dart/reg_success.dart';

class RegSuccessVM extends ViewModelBase {
  RegSuccessVM({
    required super.context, 
    required super.update,
  });

  Future<bool> tryRegDriver() async {
    var regForm = NannyDriverGlobals.driverRegForm;
    var result = await NannyAuthApi.regDriver(regForm);

    if(!result.success) return false;
    return true;
  }

  void tryAgain() {
    Navigator.pushReplacement(
      context, 
      MaterialPageRoute(builder: (context) => const RegSuccessView()),
    );
  }
}