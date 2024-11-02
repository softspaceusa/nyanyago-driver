import 'package:flutter/material.dart';
import 'package:nanny_components/nanny_components.dart';
import 'package:nanny_core/api/api_models/static_data.dart';
import 'package:nanny_core/nanny_core.dart';
import 'package:nanny_driver/globals.dart';
import 'package:nanny_driver/views/reg_pages/step_two.dart';

class RegStepOneVM extends ViewModelBase {
  RegStepOneVM({
    required super.context,
    required super.update,
    required this.nextStepCall,
  });

  final Function(int) nextStepCall;
  DriverUserData regForm = NannyDriverGlobals.driverRegForm;

  GlobalKey<FormState> passState = GlobalKey<FormState>();
  GlobalKey<FormState> innState = GlobalKey<FormState>();
  GlobalKey<FormState> cityState = GlobalKey<FormState>();
  String password = "";

  final TextEditingController cityTextController = TextEditingController();

  String refCode = "";
  String inn = "";
  StaticData city = StaticData();

  void searchForCity() async {
    var city = await showSearch(
      context: context,
      delegate: NannySearchDelegate(
        searchLabel: "Поиск города...",
        onSearch: (query) =>
            NannyStaticDataApi.getCities(StaticData(title: query)),
        onResponse: (response) => response.response,
        tileBuilder: (data, close) => ListTile(
          title: Text(data.title),
          onTap: close,
        ),
      ),
    );

    if (city == null) return;

    this.city = city;
    cityTextController.text = city.title;
  }

  void nextStep() {
    if (!passState.currentState!.validate() ||
        !cityState.currentState!.validate()) return;

    regForm.driverData =
        regForm.driverData.copyWith(city: city.id, refCode: refCode, inn: inn);

    regForm.password = Md5Converter.convert(password);
    nextStepCall(1);
    Navigator.of(context).pushNamed('step2');
  }
}
