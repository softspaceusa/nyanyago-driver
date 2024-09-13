import 'package:nanny_components/dialogs/loading.dart';
import 'package:nanny_components/nanny_components.dart';
import 'package:nanny_core/nanny_core.dart';

class OtherParamsVM extends ViewModelBase {
  OtherParamsVM({
    required super.context, 
    required super.update,
  });

  void paramAction(Future<ApiResponse> request) async {
    LoadScreen.showLoad(context, true);

    bool success = await DioRequest.handleRequest(
      context, 
      request,
    );

    if(!success) return;
    if(!context.mounted) return;

    LoadScreen.showLoad(context, false);
    NannyDialogs.showMessageBox(context, "Успех", "Данные изменены!");

    update(() {});
  }
}