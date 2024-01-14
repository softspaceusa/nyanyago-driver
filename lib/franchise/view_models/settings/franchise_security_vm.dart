import 'package:nanny_components/dialogs/loading.dart';
import 'package:nanny_components/nanny_components.dart';
import 'package:nanny_core/models/settings_data.dart';
import 'package:nanny_core/nanny_core.dart';

class FranchiseSecurityVM extends ViewModelBase {
  FranchiseSecurityVM({
    required super.context, 
    required super.update,
  });

  List<SettingsData> panelData = [
    SettingsData(
      name: "Администратор", 
      enabled: false
    ),
    SettingsData(
      name: "Менеджер", 
      enabled: false
    ),
    SettingsData(
      name: "Оператор", 
      enabled: false
    ),
  ];

  List<SettingsData> permissionsData = [
    SettingsData(
      name: "Администратор", 
      enabled: false
    ),
    SettingsData(
      name: "Менеджер", 
      enabled: false
    ),
    SettingsData(
      name: "Оператор", 
      enabled: false
    ),
  ];


  void changeValue(SettingsData data, String type) {
    switch(type) {
      case "panel":
      changePanelAccess(data);
      break;

      case "permissions":

      break;
      
      default:
        throw Exception("HHUUH?");
    }
  }

  void changePanelAccess(SettingsData data) async { // TODO: Доделать!!!
    LoadScreen.showLoad(context, true);
    
    bool success = await DioRequest.handleRequest(
      context,
      Future<ApiResponse>(() => ApiResponse())
    );

    if(!success) return;
    if(!context.mounted) return;

    LoadScreen.showLoad(context, false);
    update(() {});
  }
}