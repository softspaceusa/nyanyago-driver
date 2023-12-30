import 'package:nanny_core/nanny_core.dart';

class NannyDriverGlobals {
  DriverRegData driverRegForm = DriverRegData();
}

class DriverRegData {
  DriverRegData() {
    driverData = Driver.createRegForm();
    userData = UserInfo.createDriverRegForm();
  }

  late final Driver driverData;
  late final UserInfo userData;
}