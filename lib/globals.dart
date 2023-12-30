import 'package:nanny_core/nanny_core.dart';

class NannyDriverGlobals {
  static DriverRegData driverRegForm = DriverRegData();
  void resetRegForm() => driverRegForm = DriverRegData();
}

class DriverRegData {
  DriverRegData() {
    driverData = Driver.createRegForm();
    userData = UserInfo.createDriverRegForm();
  }

  late Driver driverData;
  late UserInfo userData;
}