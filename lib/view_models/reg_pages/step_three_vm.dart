import 'package:flutter/material.dart';
import 'package:nanny_components/nanny_components.dart';
import 'package:nanny_core/api/api_models/car_model_data.dart';
import 'package:nanny_core/api/api_models/static_data.dart';
import 'package:nanny_core/nanny_core.dart';
import 'package:nanny_driver/globals.dart';
import 'package:nanny_driver/views/reg_pages.dart/step_four.dart';

class StepThreeVM extends ViewModelBase {
  StepThreeVM({
    required super.context, 
    required super.update
  });

  RegDriverRequest regForm = NannyDriverGlobals.driverRegForm;
  
  TextEditingController markController = TextEditingController();
  TextEditingController modelController = TextEditingController();
  TextEditingController colorController = TextEditingController();
  TextEditingController yearController = TextEditingController();

  GlobalKey<FormState> markState = GlobalKey();
  GlobalKey<FormState> modelState = GlobalKey();
  GlobalKey<FormState> colorState = GlobalKey();
  GlobalKey<FormState> stateNumState = GlobalKey();
  GlobalKey<FormState> stsState = GlobalKey();

  StaticData carMark = StaticData();
  CarModelData carModel = CarModelData();
  StaticData carColor = StaticData();

  bool get isMarkSelected => carMark.id != -1;

  MaskTextInputFormatter stateNumMask = MaskTextInputFormatter(
    mask: "@ ### @@",
    filter: {
      '@': RegExp(r"[А-Я]"),
      '#': RegExp(r"[0-9]"),
    }
  );
  MaskTextInputFormatter stsMask = MaskTextInputFormatter(
    mask: "## @@ ######",
    filter: {
      '@': RegExp(r"[А-Я]"),
      '#': RegExp(r"[0-9]"),
    }
  ); 

  void searchMark() async {
    var mark = await showSearch(
      context: context, 
      delegate: NannySearchDelegate(
        onSearch: (query) => NannyStaticDataApi.getCarMarks(StaticData(title: query)),
        onResponse: (response) => response.response,
      ),
    );

    if(mark == null) return;

    carMark = mark;
    markController.text = mark.title;

    if(mark.id != carModel.carMarkId) {
      carModel = CarModelData();
      modelController.text = "";

      yearController.text = "";
    }

    update(() {});
  }
  
  void searchModel() async {
    var model = await showSearch(
      context: context, 
      delegate: NannySearchDelegate(
        emptyLabel: "Кажется модели с такой маркой нет в базе данных...",
        onSearch: (query) => NannyStaticDataApi.getCarModels(
          CarModelData(
            title: query, 
            carMarkId: carMark.id < 0 ? null : carMark.id, 
          ),
        ),
        onResponse: (response) => response.response,
      ),
    );

    if(model == null) return;

    carModel = model;
    modelController.text = model.title;
    yearController.text = model.releaseYear.toString();
  }
  
  void searchColor() async {
    var color = await showSearch(
      context: context, 
      delegate: NannySearchDelegate(
        onSearch: (query) => NannyStaticDataApi.getColors(StaticData(title: query)),
        onResponse: (response) => response.response,
      ),
    );

    if(color == null) return;

    carColor = color;
    colorController.text = color.title;
  }

  void nextStep() {
    if(!markState.currentState!.validate() ||
       !modelState.currentState!.validate() ||
       !colorState.currentState!.validate() ||
       !stateNumState.currentState!.validate() ||
       !stsState.currentState!.validate()
    ) return;

    regForm.driverData = regForm.driverData.copyWith(
      carData: CarData(
        autoMark: carMark.id, 
        autoModel: carModel.id, 
        autoColor: carColor.id,
        releaseYear: carModel.releaseYear!, 
        stateNumber: stateNumMask.getUnmaskedText(), 
        ctc: stsMask.getUnmaskedText()
      ),
    );

    slideNavigateToView(const RegStepFourView());
  }
}