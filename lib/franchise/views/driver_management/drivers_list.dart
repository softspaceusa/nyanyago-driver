import 'package:flutter/material.dart';
import 'package:nanny_components/nanny_components.dart';
import 'package:nanny_core/nanny_core.dart';
import 'package:nanny_driver/franchise/view_models/driver_management.dart/driver_list_vm.dart';

class DriversListView extends StatefulWidget {
  const DriversListView({super.key});

  @override
  State<DriversListView> createState() => _DriversListViewState();
}

class _DriversListViewState extends State<DriversListView> with AutomaticKeepAliveClientMixin {
  late DriverListVM vm;

  @override
  void initState() {
    super.initState();
    vm = DriverListVM(context: context, update: setState);
  }
  
  @override
  Widget build(BuildContext context) {
    if(wantKeepAlive) super.build(context);
    
    return RequestLoader(
      request: Future<ApiResponse>(() => ApiResponse()), 
      completeView: (context, data) => Column(
        children: [
          DropdownButton<String>(
            items: const [], 
            onChanged: vm.onFilterSelected,
          ),
        ],
      ),
      errorView: (context, error) => ErrorView(errorText: error.toString()),
    );
  }
  
  @override
  bool get wantKeepAlive => true;
}