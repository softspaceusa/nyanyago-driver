import 'package:nanny_components/nanny_components.dart';
import 'package:nanny_driver/franchise/views/driver_request_view.dart';

class DriverListVM extends ViewModelBase {
  DriverListVM({
    required super.context, 
    required super.update,
  });

  bool showNewDrivers = false;

  void onFilterSelected(String? type) {
    
  }

  void listTypeChanged(bool? value) => update(() => showNewDrivers = value!);

  void toNewDriverRequest(int id) async {
    await navigateToView(DriverRequestView(id: id));
    update(() {});
  }
}