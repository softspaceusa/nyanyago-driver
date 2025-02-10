import 'package:nanny_components/dialogs/loading.dart';
import 'package:nanny_components/nanny_components.dart';
import 'package:nanny_core/api/api_models/want_schedule_request.dart';
import 'package:nanny_core/models/from_api/drive_and_map/schedule.dart';
import 'package:nanny_core/nanny_core.dart';

class ScheduleCheckerVm extends ViewModelBase {
  ScheduleCheckerVm({
    required super.context,
    required super.update,
    required this.schedule,
  }) {
    request = WantScheduleRequest()..idSchedule = 5;
  }

  Schedule schedule;
  NannyWeekday selectedWeekday =
      NannyWeekday.values[DateTime.now().weekday - 1];
  bool selectAll = false;
  List<int> idRoads = [];
  late WantScheduleRequest request;

  void weekdaySelected(DateTime date) {
    selectedWeekday = NannyWeekday.values[date.weekday - 1];
    update(() {});
  }

  void selectAllChanged(bool? value) => update(() => selectAll = value!);

  void roadSelected(int id, bool selected) {
    if (selected) {
      idRoads.add(id);
      print("Selected");
    } else {
      idRoads.remove(id);
      print("Deslected");
    }

    update(() {});
  }

  void wantSchedule() async {
    if (!selectAll && idRoads.isEmpty) {
      NannyDialogs.showMessageBox(
          context, "Ошибка!", "Выберите хотя бы один маршрут!");
      return;
    }

    LoadScreen.showLoad(context, true);

    if (selectAll) {
      List<int> roads = [];
      for (var road in schedule.roads) {
        roads.add(road.id!);
      }

      request.idRoads = roads;
    } else {
      request.idRoads = idRoads;
    }

    bool success = await DioRequest.handleRequest(
        context, NannyDriverApi.wantScheduleRequest(request));

    if (!success) {
      if (context.mounted) {
        NannyDialogs.showMessageBox(context, "Ошибка!",
            "Не удалось отправить запрос на подтверждение!");
      }
      return;
    }

    if (context.mounted) {
      LoadScreen.showLoad(context, false);
      NannyDialogs.showMessageBox(
          context, "Успех!", "Заявка отправлена на рассмотрение");
    }
  }
}
