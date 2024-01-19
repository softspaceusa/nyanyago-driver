import 'package:flutter/material.dart';
import 'package:nanny_components/base_views/views/driver_info.dart';
import 'package:nanny_driver/test/in_drive.dart';
import 'package:nanny_driver/test/map_drive.dart';
import 'package:nanny_driver/views/reg.dart';

class TestView extends StatefulWidget {
  const TestView({super.key});

  @override
  State<TestView> createState() => _TestViewState();
}

class _TestViewState extends State<TestView> {
  @override
  Widget build(BuildContext context) {
    // return const MyContractsView();
    // return MonthSelector(
    //   onMonthChanged: (month) {},
    // );
    // return const RegView();
    // return const MapDriveView();
    return const DriverInfoView();
  }
}
