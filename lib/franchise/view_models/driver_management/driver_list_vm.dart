import 'package:flutter/material.dart';
import 'package:nanny_components/dialogs/loading.dart';
import 'package:nanny_components/nanny_components.dart';
import 'package:nanny_core/api/dio_request.dart';
import 'package:nanny_core/api/nanny_admin_api.dart';
import 'package:nanny_core/constants.dart';
import 'package:nanny_core/models/from_api/user_info.dart';
import 'package:nanny_driver/franchise/views/driver_request_view.dart';

class DriverListVM extends ViewModelBase {
  DriverListVM({
    required super.context,
    required super.update,
  });

  bool showNewDrivers = false;

  void onFilterSelected(String? type) {}

  void listTypeChanged(bool? value) => update(() => showNewDrivers = value!);

  void toNewDriverRequest(int id) async {
    await navigateToView(DriverRequestView(id: id));
    update(() {});
  }

  void banUser(UserInfo user,
      {List<BuildContext>? previewDialogContexts}) async {
    if (!await NannyDialogs.confirmAction(context,
        "${user.status == UserStatus.active ? "Заблокировать" : "Разблокировать"} ${user.name}?"))
      return;
    if (!context.mounted) return;

    LoadScreen.showLoad(context, true);

    bool success = await DioRequest.handleRequest(
      context,
      NannyAdminApi.banUser(user.id),
    );

    if (!success) return;
    if (!context.mounted) return;

    // закрываем все предыдущие диалоги, если есть
    if (previewDialogContexts != null) {
      for (BuildContext element in previewDialogContexts) {
        Navigator.pop(element);
      }
    }

    LoadScreen.showLoad(context, false);
    update(() {});
  }
}
