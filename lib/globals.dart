import 'package:nanny_core/api/api_models/reg_driver_request.dart';

class NannyDriverGlobals {
  static RegDriverRequest driverRegForm = RegDriverRequest();
  void resetRegForm() => driverRegForm = RegDriverRequest();
}
