import 'package:nanny_components/dialogs/loading.dart';
import 'package:nanny_components/nanny_components.dart';
import 'package:nanny_core/api/nanny_orders_api.dart';
import 'package:nanny_core/models/from_api/drive_and_map/today_schedule_data.dart';
import 'package:nanny_core/nanny_core.dart';
import 'package:nanny_driver/views/schedule_checker.dart';

class MyContractsVM extends ViewModelBase {
  MyContractsVM({
    required super.context, 
    required super.update,
  });

  List<TodayScheduleData> schedules = [];
  bool showContracts = false;

  void changeShowContract(bool show) => update(() => showContracts = show);

  void viewSchedule(int id) async {
    LoadScreen.showLoad(context, true);

    var schedReq = NannyOrdersApi.getScheduleById(id);
    bool success = await DioRequest.handleRequest(
      context, 
      schedReq
    );

    if(!success) return;

    var schedule = await schedReq;

    navigateToView(
      ScheduleCheckerView(schedule: schedule.response!)
    );
  }

  @override
  Future<bool> loadPage() async {
    var schedRes = await NannyDriverApi.getTodaySchedules();
    if(!schedRes.success) return false;

    schedules = schedRes.response!;
    
    return true;
  }
}