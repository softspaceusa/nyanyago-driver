import 'package:flutter/material.dart';
import 'package:nanny_components/base_views/view_models/graph_stats_vm.dart';
import 'package:nanny_components/base_views/views/table_stats.dart';
import 'package:nanny_components/nanny_components.dart';
import 'package:nanny_core/nanny_core.dart';

class GraphStatsView extends StatefulWidget {
  final String title;
  final bool getUsersReport;

  const GraphStatsView({
    super.key,
    required this.title,
    required this.getUsersReport,
  });

  @override
  State<GraphStatsView> createState() => _GraphStatsViewState();
}

class _GraphStatsViewState extends State<GraphStatsView> {
  late GraphStatsVM vm;

  @override
  void initState() {
    super.initState();
    vm = GraphStatsVM(context: context, update: setState, getUsersReport: widget.getUsersReport);
  }
  
  @override
  Widget build(BuildContext context) {
    return FutureLoader(
      future: vm.loadRequest,
      completeView: (context, data) {
        if(!data) return const ErrorView(errorText: "Не удалось загрузить данные!");

        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
        
            Text(widget.title, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 10),
            SegmentedButton(
              style: ElevatedButton.styleFrom(
                disabledBackgroundColor: NannyTheme.lightGreen,
                disabledForegroundColor: NannyTheme.onSecondary
              ),
              showSelectedIcon: false,
              segments: DateType.values.map(
                (e) => ButtonSegment<DateType>(
                  value: e,
                  label: Text(e.name),
                  enabled: vm.selectedDateType != e
                ),
              ).toList(),
              selected: {vm.selectedDateType},
              onSelectionChanged: vm.onSelect,
            ),
            const SizedBox(height: 10),
            Row(
              children: [
        
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {}, 
                    child: const Text("График")
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => vm.navigateToView(TableStatsView(getUsersReport: widget.getUsersReport)), 
                    style: NannyButtonStyles.whiteButton,
                    child: const Text("Таблица"),
                  ),
                ),
                
              ],
            ),
            AspectRatio(
              aspectRatio: 16 / 9,
              child: DChartLineN(
                groupList: [
                  NumericGroup(
                    id: "1", 
                    data: vm.data.isEmpty ? [] : vm.data.asMap().entries.map(
                      (e) => NumericData(
                        domain: e.key + 1, 
                        measure: e.value
                      )
                    ).toList()
                  ),
                ]
              ),
            ),
            ElevatedButton(
              onPressed: vm.downloadReport, 
              child: const Text("Скачать отчет"),
            ),
        
          ],
        );
      },
      errorView: (context, error) => ErrorView(errorText: error.toString()),
    );
  }
}
