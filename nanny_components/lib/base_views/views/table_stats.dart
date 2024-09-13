import 'package:flutter/material.dart';
import 'package:nanny_components/base_views/view_models/table_stats_vm.dart';
import 'package:nanny_components/nanny_components.dart';
import 'package:nanny_core/constants.dart';

class TableStatsView extends StatefulWidget {
  const TableStatsView({
    super.key,
    required this.getUsersReport,
  });

  final bool getUsersReport;

  @override
  State<TableStatsView> createState() => _TableStatsViewState();
}

class _TableStatsViewState extends State<TableStatsView> {
  late TableStatsVM vm;

  @override
  void initState() {
    super.initState();
    vm = TableStatsVM(context: context, update: setState, getUsersReport: widget.getUsersReport);
  }
  
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            const SizedBox(height: 50),
            Expanded(
              child: NannyBottomSheet(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [

                    const Text("Отчет о продаже"),
                    const SizedBox(height: 10),
                    SegmentedButton<DateType>(
                      style: ElevatedButton.styleFrom(
                        disabledBackgroundColor: NannyTheme.lightGreen,
                        disabledForegroundColor: NannyTheme.onSecondary
                      ),
                      showSelectedIcon: false,
                      segments: DateType.values.map(
                        (e) => ButtonSegment<DateType>(
                          value: e,
                          label: Text(e.name),
                          enabled: e != vm.selectedDateType
                        )
                      ).toList(), 
                      selected: { vm.selectedDateType },
                      onSelectionChanged: vm.onSelect,
                    ),
                    const SizedBox(height: 10),
                    Table(
                      children: vm.data.isEmpty ? [] 
                        : vm.data.map(
                          (e) => TableRow(
                            children: [
                              TableCell(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(e.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                                    Text(e.description),
                                  ],
                                )
                              ),
                              TableCell(
                                child: Text(e.value.toString())
                              )
                            ]
                          )
                        ).toList(),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: vm.downloadReport, 
                      child: const Text("Скачать отчет"),
                    ),

                  ],
                )
              ),
            )
          ],          
        ),
      ),
    );
  }
}