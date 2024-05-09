import 'package:nanny_components/nanny_components.dart';
import 'package:nanny_core/api/nanny_franchise_api.dart';
import 'package:nanny_core/api/nanny_orders_api.dart';
import 'package:nanny_core/models/from_api/drive_and_map/drive_tariff.dart';
import 'package:nanny_core/models/from_api/response_new_driver_request.dart';
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
  void answerRequest({required bool accept}) async {
    if(maxAllowedTariffId < 1) {
      NannyDialogs.showMessageBox(context, "Ошибка", "Выберите хотя бы один тариф!");
      return;
    }
    
    List<int> allowedTariffs = [];
    for(int i = 1; i <= maxAllowedTariffId; i++) { allowedTariffs.add(i); }
    if(tariffs.where((e) => e.id == -1).isNotEmpty) allowedTariffs.add(-1);

    var result = await DioRequest.handle(
      context, 
      NannyFranchiseApi.responseNewDriver(
        ResponseNewDriverRequest(
          idDriver: id,
          success: accept,
          idTariff: allowedTariffs
        )
      )
    );

    if(!result.success) return;
    if(!context.mounted) return;

    await NannyDialogs.showMessageBox(context, "Успех", "Заявка ${accept ? "принята" : "отклонена"}");
    popView();
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