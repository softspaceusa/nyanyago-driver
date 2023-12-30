import 'package:flutter/material.dart';
import 'package:nanny_components/nanny_components.dart';
import 'package:nanny_core/models/from_api/drive_and_map/geocoding_data.dart';
import 'package:nanny_core/nanny_core.dart';
import 'package:nanny_driver/globals.dart';

class RegStepOneVM extends ViewModelBase {
  RegStepOneVM({
    required super.context, 
    required super.update,
  });

  DriverRegData regForm = NannyDriverGlobals.driverRegForm;

  GlobalKey<FormState> passwordState = GlobalKey<FormState>();

  void searchForCity() {
    showSearch(
      context: context, 
      delegate: NannySearchDelegate<GeocodeData>(),
    );
  }
}