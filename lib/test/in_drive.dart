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
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          const Text("В пути..."),
          Text("Осталось: ${vm.distanceLeft.toStringAsFixed(2)} км"),
          LinearProgressIndicator(value: vm.drivePercent),
          const SizedBox(height: 50),
          ElevatedButton(
            onPressed: vm.atEnd ? vm.endDrive : null, 
            child: const Text("Завершить поездку")
          ),
        ],
      ),
    );
  }
}