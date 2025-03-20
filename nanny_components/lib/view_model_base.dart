import 'package:flutter/material.dart';
import 'package:nanny_components/dialogs/loading.dart';
import 'package:nanny_components/dialogs/nanny_dialogs.dart';
import 'package:nanny_core/api/api_models/decline_roads_request.dart';
import 'package:nanny_core/api/dio_request.dart';
import 'package:nanny_core/api/nanny_driver_api.dart';
import 'package:nanny_core/models/from_api/drive_and_map/schedule.dart';

abstract class ViewModelBase {
  final BuildContext context;
  void Function(VoidCallback fun) update;

  ViewModelBase({required this.context, required this.update}) {
    _loadRequest = loadPage();
  }

  DeclineRoadsRequests declineRoadsRequests = DeclineRoadsRequests();

  Future<void> navigateToView(Widget view) async => await Navigator.push(
      context, MaterialPageRoute(builder: (context) => view));

  Future<void> cancelSchedule(Schedule schedule) async {
    if (!await NannyDialogs.confirmAction(
        context, "Вы уверены, что хотите отказаться от графика?",
        confirmText: 'Да', cancelText: 'Нет')) {
      return;
    }

    LoadScreen.showLoad(context, true);

    declineRoadsRequests.idRoads = schedule.roads.map((e) => e.id!).toList();

    bool success = await DioRequest.handleRequest(
        context, NannyDriverApi.declineRoadsRequests(declineRoadsRequests));

    if (!success) {
      if (context.mounted) {
        NannyDialogs.showMessageBox(
            context, "Ошибка!", "Заявка не была отправлена");
      }
      return;
    }

    if (context.mounted) {
      LoadScreen.showLoad(context, false);
      NannyDialogs.showMessageBox(
          context, "Успех!", "Ваша заявка на удаление отправлена клиенту");
    }
  }

  Future slideNavigateToView(Widget view,
          {Offset beginOffset = const Offset(0, 1)}) async =>
      Navigator.push(
          context,
          PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) => view,
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                const Offset end = Offset(0, 0);
                final Tween<Offset> tween = Tween(begin: beginOffset, end: end);
                final CurveTween curve = CurveTween(curve: Curves.easeInOut);

                return SlideTransition(
                    position: animation.drive(tween.chain(curve)),
                    child: child);
              }));

  void popView() => Navigator.pop(context);

  Future<bool> _loadRequest = Future(() => true);

  Future<bool> get loadRequest => _loadRequest;

  /// `true` - если все данные загрузились, иначе `false`
  Future<bool> loadPage() async => true;

  void reloadPage() => update(() {
        _loadRequest = loadPage();
      });
}
