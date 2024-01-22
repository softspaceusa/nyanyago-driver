import 'package:flutter/material.dart';

class DriveCompleteView extends StatefulWidget {
  const DriveCompleteView({super.key});

  @override
  State<DriveCompleteView> createState() => _DriveCompleteViewState();
}

class _DriveCompleteViewState extends State<DriveCompleteView> {
  @override
  Widget build(BuildContext context) {
    return const Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("Поездка завершена!"),
      ],
    );
  }
}