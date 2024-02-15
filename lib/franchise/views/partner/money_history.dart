import 'package:flutter/material.dart';
import 'package:nanny_components/nanny_components.dart';
import 'package:nanny_components/widgets/date_type_segment.dart';

class MoneyHistoryView extends StatefulWidget {
  const MoneyHistoryView({super.key});

  @override
  State<MoneyHistoryView> createState() => _MoneyHistoryViewState();
}

class _MoneyHistoryViewState extends State<MoneyHistoryView> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: const NannyAppBar(
          title: "Управление отчетами",
        ),
        body: Column(
          children: [
            const SizedBox(height: 100),
            Expanded(
              child: NannyBottomSheet(
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    children: [
                  
                      DateTypeSegment(
                        onChanged: (type) {},
                      ),
                      const SizedBox(height: 10),
                      Expanded(
                        child: ListView(
                          shrinkWrap: true,
                          children: const [
                            Center(
                              child: Text("Список пуст...")
                            )
                          ],
                        )
                      ),
                      
                    ],
                  ),
                )
              )
            )
          ],
        ),
      ),
    );
  }
}