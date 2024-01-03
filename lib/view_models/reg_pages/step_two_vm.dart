import 'package:flutter/material.dart';
import 'package:nanny_components/nanny_components.dart';
import 'package:nanny_core/api/api_models/static_data.dart';
import 'package:nanny_core/nanny_core.dart';
import 'package:nanny_driver/globals.dart';
import 'package:nanny_driver/views/reg_pages.dart/step_three.dart';

class StepTwoVM extends ViewModelBase {
  StepTwoVM({
    required super.context, 
    required super.update,
  });

  DriverRegData regForm = NannyDriverGlobals.driverRegForm;

  GlobalKey<FormState> countryState = GlobalKey();
  TextEditingController countryTextController = TextEditingController();
  StaticData country = StaticData();

  GlobalKey<FormState> nameState = GlobalKey();
  String name = "";

  GlobalKey<FormState> surnameState = GlobalKey();
  String surname = "";

  GlobalKey<FormState> driveLicenseState = GlobalKey();
  MaskTextInputFormatter driveLicenseMask = MaskTextInputFormatter(
    mask: "## ## ######",
    filter: {
      '#': RegExp(r"[0-9]")
    }
  );
  GlobalKey<FormState> receiveDateState = GlobalKey();
  MaskTextInputFormatter receiveDateMask = MaskTextInputFormatter(
    mask: "##.##.####",
    filter: {
      '#': RegExp(r"[0-9]")
    }
  );

  void searchCountry() async {
    var country = await showSearch(
      context: context, 
      delegate: NannySearchDelegate(
        onSearch: (query) => NannyStaticDataApi.getCountries( StaticData(title: query) ), 
      ),
    );

    if(country == null) return;

    this.country = country;
    countryTextController.text = country.title;
  }
  
  void nextStep() {
    if(!countryState.currentState!.validate() ||
       !surnameState.currentState!.validate() ||
       !nameState.currentState!.validate() ||
       !driveLicenseState.currentState!.validate() ||
       !receiveDateState.currentState!.validate()
    ) return;

    regForm.driverData = regForm.driverData.copyWith(
      driverLicense: DriverLicense(
        license: driveLicenseMask.getUnmaskedText(),
        receiveCountry: country.id,
        receiveDate: receiveDateMask.getMaskedText(),
      ),
    ); 

    regForm.userData = regForm.userData.copyWith(
      name: name,
      surname: surname,
    );

    slideNavigateToView(const RegStepThreeView());
  }
}