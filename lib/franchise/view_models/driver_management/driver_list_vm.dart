import 'package:nanny_components/nanny_components.dart';

class DriverListVM extends ViewModelBase {
  DriverListVM({
    required super.context, 
    required super.update,
  });

  bool showNewDrivers = false;

  void onFilterSelected(String? type) {
    
  }

  void listTypeChanged(bool? value) => update(() => showNewDrivers = value!);
}