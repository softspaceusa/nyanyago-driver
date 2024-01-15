import 'package:flutter/material.dart';
import 'package:nanny_driver/test/in_drive_vm.dart';

class InDriveView extends StatefulWidget {
  const InDriveView({super.key});

  @override
  State<InDriveView> createState() => _InDriveViewState();
}

class _InDriveViewState extends State<InDriveView> {
  late InDriveVM vm;

  @override
  void initState() {
    super.initState();
    vm = InDriveVM(context: context, update: setState);
  }
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [

      ],
    );
  }
}