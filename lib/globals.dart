import 'package:nanny_core/api/api_models/driver_user_request.dart';

class NannyDriverGlobals {
  static DriverUserData driverRegForm = DriverUserData();
  void resetRegForm() => driverRegForm = DriverUserData();
}
