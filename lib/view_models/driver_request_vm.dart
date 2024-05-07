import 'package:nanny_components/nanny_components.dart';
import 'package:nanny_core/api/nanny_orders_api.dart';
import 'package:nanny_core/models/from_api/drive_and_map/drive_tariff.dart';
import 'package:nanny_core/nanny_core.dart';

class DriverRequestVM extends ViewModelBase {
  DriverRequestVM({
    required super.context, 
    required super.update,
    required this.id,
  });

  final int id;

  late DriverUserTextData driver;
  late List<DriveTariff> tariffs;

  int maxAllowedTariffId = 0;
  void changeMaxTariff(int id) => update(() => maxAllowedTariffId = id);  
  void answerRequest({required bool accept}) {
    List<int> allowedTariffs = [];
    for(int i = 1; i <= maxAllowedTariffId; i++) { allowedTariffs.add(i); }
  }

  @override
  Future<bool> loadPage() async {
    var res = await NannyOrdersApi.getDriver(id);
    if(!res.success) return false;

    driver = res.response!;
    driver.userData = driver.userData.asDriver();

    var tariffRes = await NannyStaticDataApi.getTariffs();
    if(!tariffRes.success) return false;

    tariffs = tariffRes.response!;

    return true;
  }
}