import 'package:nanny_components/dialogs/loading.dart';
import 'package:nanny_components/nanny_components.dart';
import 'package:nanny_core/api/nanny_orders_api.dart';
import 'package:nanny_core/models/from_api/drive_and_map/today_schedule_data.dart';
import 'package:nanny_core/nanny_core.dart';

class DriverScheduleVM extends ViewModelBase {
  DriverScheduleVM({
    required super.context, 
    required super.update,
  });

  List<TodayScheduleData> schedules = [];

  void viewSchedule(int id) async { // TODO: Нужен Road Viewer
    LoadScreen.showLoad(context, true);

    var roadReq = NannyOrdersApi.getScheduleRoadById(id);
    bool success = await DioRequest.handleRequest(
      context, 
      roadReq
    );

    if(!success) return;

    // var schedule = await schedReq;

    // navigateToView(
    //   ScheduleCheckerView(schedule: schedule.response!)
    // );
  }

  @override
  Future<bool> loadPage() async {
    var schedRes = await NannyDriverApi.getTodaySchedules();
    if(!schedRes.success) return false;

    schedules = schedRes.response!;
    
    return true;
  }
}