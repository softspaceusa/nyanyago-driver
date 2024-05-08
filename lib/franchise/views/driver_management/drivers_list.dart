import 'package:flutter/material.dart';
import 'package:nanny_components/base_views/views/driver_info.dart';
import 'package:nanny_components/nanny_components.dart';
import 'package:nanny_driver/franchise/view_models/driver_management/driver_list_vm.dart';
import 'package:nanny_driver/franchise/views/driver_request_view.dart';

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
    
    return Column(
      children: [
        CheckboxListTile(
          title: Text("Показать заявки новых водителей", style: Theme.of(context).textTheme.labelLarge),
          value: vm.showNewDrivers, 
          onChanged: vm.listTypeChanged,
          activeColor: NannyTheme.primary,
        ),
        Expanded(
          child: FranchiseDriverList(
            showNewDrivers: vm.showNewDrivers,
            
            filterItems: const [], 
            itemLabel: (item) => "", 
            onItemChanged: (item) {}, 
            onDriverTap: (user) => vm.showNewDrivers ? 
              vm.navigateToView(
                DriverRequestView(id: user.id)
              )
              :
              NannyDialogs.showModalDialog(
                context: context, 
                hasDefaultBtn: false,
                title: "${user.name} ${user.surname}",
                child: Column(
                  children: [
                    ElevatedButton.icon(
                      onPressed: () => vm.navigateToView(
                        DriverInfoView(id: user.id)
                      ), 
                      label: const Text("Просмотреть профиль"),
                      icon: const Icon(Icons.person),
                    ),
                    const SizedBox(height: 40),
                    ElevatedButton.icon(
                      onPressed: () {}, 
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red.shade400
                      ),
                      label: const Text("Заблокировать"),
                      icon: const Icon(Icons.block),
                    ),
                  ],
                ),
              )
          ),
        ),
      ],
    );
  }
  
  @override
  bool get wantKeepAlive => true;
}