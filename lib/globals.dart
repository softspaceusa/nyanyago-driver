import 'package:nanny_core/api/api_models/driver_user_data.dart';

class NannyDriverGlobals {
  static DriverUserData driverRegForm = DriverUserData.createRegForm();
  void resetRegForm() => driverRegForm = DriverUserData.createRegForm();
}
