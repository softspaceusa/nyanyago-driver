import 'package:flutter/material.dart';
import 'package:nanny_components/base_views/views/driver_info.dart';
import 'package:nanny_components/nanny_components.dart';
import 'package:nanny_driver/franchise/view_models/driver_payments_vm.dart';

class DriverPaymentsView extends StatefulWidget {
  const DriverPaymentsView({super.key});

  @override
  State<DriverPaymentsView> createState() => _DriverPaymentsViewState();
}

class _DriverPaymentsViewState extends State<DriverPaymentsView> {
  late DriverPaymentsVM vm;

  @override
  void initState() {
    super.initState();
    vm = DriverPaymentsVM(context: context, update: setState);
  }
  
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: const NannyAppBar(
          isTransparent: false,
          title: "Выплаты водителям",
        ),
        body: FranchiseDriverList(
          showNewDrivers: false,
          
          filterItems: const [], 
          itemLabel: (item) => "", 
          onItemChanged: (item) {}, 
          onDriverTap: (user) => vm.navigateToView(
            DriverInfoView(
              id: user.id,
              hasPaymentButtons: true,
            )
          ),
        ),
      ),
    );
  }
}