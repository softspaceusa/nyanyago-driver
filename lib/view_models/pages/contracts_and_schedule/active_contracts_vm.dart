import 'package:nanny_components/nanny_components.dart';
import 'package:nanny_core/api/nanny_driver_api.dart';
import 'package:nanny_core/api/nanny_static_data_api.dart';
import 'package:nanny_core/models/from_api/drive_and_map/driver_schedule_response.dart';
import 'package:nanny_core/models/from_api/other_parametr.dart';

class ActiveContractsVM extends ViewModelBase {
  ActiveContractsVM({
    required super.context,
    required super.update,
  });

  List<DriverScheduleResponse> contracts = [];
  List<OtherParametr> params = [];

  @override
  Future<bool> loadPage() async {
    var paramRes = await NannyStaticDataApi.getOtherParams();
    if (!paramRes.success) return false;
    params = paramRes.response ?? [];

    var driverRoadIdsRes = (await NannyDriverApi.getDriverRoads());

    if (!driverRoadIdsRes.success) return false;

    List<int> driverRoadIds = driverRoadIdsRes.response ?? [];

    if (driverRoadIds.isNotEmpty) {
      var schedRes = (await NannyDriverApi.getFullRoadsInfo(
        driverRoadIds.join(','),
      ));

      if (!schedRes.success) return false;

      contracts = schedRes.response!;
    }

    return true;
  }
}
