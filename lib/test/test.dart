import 'package:flutter/material.dart';
import 'package:nanny_driver/views/pages/my_contracts.dart';

class TestView extends StatefulWidget {
  const TestView({super.key});

  @override
  State<TestView> createState() => _TestViewState();
}

class _TestViewState extends State<TestView> {
  @override
  Widget build(BuildContext context) {
    return const MyContractsView();
  }
}
