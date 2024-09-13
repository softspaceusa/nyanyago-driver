import 'package:flutter/material.dart';
import 'package:nanny_components/dialogs/loading.dart';
import 'package:nanny_components/nanny_components.dart';
import 'package:nanny_core/api/api_models/create_user_request.dart';
import 'package:nanny_core/api/api_models/static_data.dart';
import 'package:nanny_core/nanny_core.dart';

class FranchiseCreateVM extends ViewModelBase {
  FranchiseCreateVM({
    required super.context, 
    required super.update,
  });

  final List<FranchiseCheckBoxData> _items = [
    FranchiseCheckBoxData(
      checked: false,
      type: UserType.franchiseAdmin,
    ),
    FranchiseCheckBoxData(
      checked: false,
      type: UserType.manager,
    ),
    FranchiseCheckBoxData(
      checked: false,
      type: UserType.operator,
    ),
  ];
  List<FranchiseCheckBoxData> get items => _items;

  GlobalKey<FormState> phoneState = GlobalKey();
  GlobalKey<FormState> passwordState = GlobalKey();
  GlobalKey<FormState> cityState = GlobalKey();

  UserType? selectedType;

  String get phone => "7${phoneMask.getUnmaskedText()}";
  MaskTextInputFormatter phoneMask = TextMasks.phoneMask();

  String password = "";
  String name = "";
  String surname = "";
  List<StaticData> selectedCities = [];

  void selectCity() async {
    var city = await showSearch(
      context: context, 
      delegate: NannySearchDelegate(
        onSearch: (query) => NannyStaticDataApi.getCities(
          StaticData(title: query)
        ), 
        onResponse: (response) => response.response,
      )
    );

    if(city == null) return;
    if(selectedCities.where((e) => e.id == city.id).isNotEmpty) return;

    selectedCities.add(city);
    update(() {});
  }

  void removeCity(StaticData city) {
    selectedCities.remove(city);
    update(() {});
  }

  void changeSelection(FranchiseCheckBoxData data) {
    for (var e in _items) {
      e.checked = false;
    }
    data.checked = true;
    selectedType = data.type;
    update(() {});
  }

  void createUser() async {
    if(!phoneState.currentState!.validate() || 
       !passwordState.currentState!.validate()) return;

    if(selectedCities.isEmpty) {
      NannyDialogs.showMessageBox(context, "Ошибка", "Выберите город(а)!");
      return;
    }

    if(selectedType == null) {
      NannyDialogs.showMessageBox(context, "Ошибка", "Выберите роль!");
      return;
    }

    LoadScreen.showLoad(context, true);

    bool success = await DioRequest.handleRequest(
      context, 
      NannyAdminApi.createUser(
        CreateUserRequest(
          phone: phone, 
          password: password, 
          name: name, 
          surname: surname, 
          role: selectedType!.id,
          idCity: selectedCities.map((e) => e.id).toList()
        )
      )
    );

    if(!success) return;
    if(!context.mounted) return;
    
    LoadScreen.showLoad(context, false);

    await NannyDialogs.showMessageBox(context, "Успех", "Пользователь создан");

    if(!context.mounted) return;
    Navigator.pop(context);
  }
}

class FranchiseCheckBoxData {
  FranchiseCheckBoxData({
    required this.checked,
    required this.type
  });

  bool checked;
  final UserType type;
}