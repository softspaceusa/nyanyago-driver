import 'package:flutter/material.dart';
import 'package:nanny_components/nanny_components.dart';
import 'package:nanny_driver/franchise/view_models/stats_vm.dart';

class StatsView extends StatefulWidget {
  const StatsView({super.key});

  @override
  State<StatsView> createState() => _StatsViewState();
}

class _StatsViewState extends State<StatsView> {
  late StatsVM vm;

  @override
  void initState() {
    super.initState();
    vm = StatsVM(context: context, update: setState);
  }
  
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: const NannyAppBar(
          isTransparent: false,
          title: "Статистика и отчеты",
        ),
        body: ListView(
          padding: const EdgeInsets.all(10),
          children: [

            statTile(
              label: "Зарегистрированных пользователей", 
              value: "0 человек",
            ),
            statTile(
              label: "Число заказов", 
              value: "0 заказов",
            ),
            statTile(
              label: "Общая сумма выплат водителям", 
              value: "0 р",
            ),
            
          ],
        ),
      ),
    );
  }

  Widget statTile({
    required String label,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label, 
            style: Theme.of(context).textTheme.titleMedium,
          ),
          Text(
            value, 
            style: Theme.of(context).textTheme.labelLarge
              ?.copyWith(color: NannyTheme.primary),
          ),
          const SizedBox(height: 10),
          const Divider(color: NannyTheme.onSecondary),
        ],
      ),
    );
  }
}