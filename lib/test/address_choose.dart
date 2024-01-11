import 'package:flutter/material.dart';
import 'package:nanny_components/nanny_components.dart';
import 'package:nanny_driver/test/address_choose_vm.dart';

class AddressChooseView extends StatefulWidget {
  final BuildContext baseContext;
  
  const AddressChooseView({
    super.key,
    required this.baseContext,
  });

  @override
  State<AddressChooseView> createState() => _AddressChooseViewState();
}

class _AddressChooseViewState extends State<AddressChooseView> {
  late AddressChooseVM vm;

  @override
  void initState() {
    super.initState();
    vm = AddressChooseVM(context: context, update: setState, baseContext: widget.baseContext);
  }
  
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          NannyTextForm(
            controller: vm.aController,
            readOnly: true,
            labelText: "Поиск адреса",
            onTap: () => vm.searchAddress(0),
          ),
          const SizedBox(height: 10),
          NannyTextForm(
            controller: vm.bController,
            readOnly: true,
            labelText: "Поиск адреса",
            onTap: () => vm.searchAddress(1),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: vm.setPolyline, 
            child: const Text("Задать маршрут")
          ),
        ],
      ),
    );
  }
}