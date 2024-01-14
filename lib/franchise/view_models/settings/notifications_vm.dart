import 'package:nanny_components/dialogs/loading.dart';
import 'package:nanny_components/nanny_components.dart';
import 'package:nanny_core/models/settings_data.dart';
import 'package:nanny_core/nanny_core.dart';

class NotificationsVM extends ViewModelBase {
  NotificationsVM({
    required super.context, 
    required super.update,
  });

  final List<SettingsData> data = [
    SettingsData(
      name: "Акции", 
      enabled: false,
    ),
    SettingsData(
      name: "Новые функции",
      enabled: false,
    ),
    SettingsData(
      name: "Рекомендуемые поездки", 
      enabled: false,
    ),
    SettingsData(
      name: "Партнерские программы", 
      enabled: false,
    ),
  ];

  void changeValue(SettingsData data) async {
    late Future<ApiResponse<bool>> request;
    
    switch(data.name) {
      case "Акции":
        request = Future<ApiResponse<bool>>(() => ApiResponse());
      break;

      case "Новые функции":
        request = Future<ApiResponse<bool>>(() => ApiResponse());
      break;

      case "Рекомендуемые поездки":
        request = Future<ApiResponse<bool>>(() => ApiResponse());
      break;

      case "Партнерские программы":
        request = Future<ApiResponse<bool>>(() => ApiResponse());
      break;
      
      default:
        throw Exception("HUH?");
    }

    LoadScreen.showLoad(context, true);
    bool success = await DioRequest.handleRequest(context, request);

    data.enabled = (await request).response!;

    if(!success) return;
    if(!context.mounted) return;

    LoadScreen.showLoad(context, false);
    update(() {});
  }
}
