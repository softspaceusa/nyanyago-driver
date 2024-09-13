import 'package:flutter/material.dart';
import 'package:nanny_components/nanny_components.dart';
import 'package:nanny_components/base_views/views/graph_stats.dart';

class ReportsManagementView extends StatefulWidget {
  const ReportsManagementView({super.key});

  @override
  State<ReportsManagementView> createState() => _ReportsManagementViewState();
}

class _ReportsManagementViewState extends State<ReportsManagementView> { // TODO: Доделать!
  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: Scaffold(
        appBar: NannyAppBar(
          title: "Управление отчетами",
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                GraphStatsView(
                  title: "Отчет о продажах",
                  getUsersReport: false,
                ),
                SizedBox(height: 50),
                GraphStatsView(
                  title: "Отчет о пользователях",
                  getUsersReport: true,
                ),
              ],
            ),
          ),
        )
      ),
    );
  }
}