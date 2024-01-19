import 'package:flutter/material.dart';
import 'package:nanny_core/map_services/drive_manager.dart';
import 'package:nanny_driver/test/in_drive_vm.dart';

class InDriveView extends StatefulWidget {
  final DriveManager driveManager;
  
  const InDriveView({
    super.key,
    required this.driveManager,
  });

  @override
  State<InDriveView> createState() => _InDriveViewState();
}

class _InDriveViewState extends State<InDriveView> {
  late InDriveVM vm;

  @override
  void initState() {
    super.initState();
    vm = InDriveVM(context: context, update: setState, driveManager: widget.driveManager);
  }
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        
      ],
    );
  }
}