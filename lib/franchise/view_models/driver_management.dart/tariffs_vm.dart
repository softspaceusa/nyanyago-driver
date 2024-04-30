import 'package:nanny_components/nanny_components.dart';
import 'package:nanny_core/models/from_api/drive_and_map/drive_tariff.dart';
import 'package:nanny_core/nanny_core.dart';

class TariffsVM extends ViewModelBase {
  TariffsVM({
    required super.context, 
    required super.update
  });

  Future< ApiResponse<List<DriveTariff>> > request = NannyStaticDataApi.getTariffs();
}