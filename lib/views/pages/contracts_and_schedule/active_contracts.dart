import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nanny_components/models/active_contracts.dart';
import 'package:nanny_components/nanny_components.dart';
import 'package:nanny_core/constants.dart';
import 'package:nanny_core/nanny_core.dart';
import 'package:nanny_driver/view_models/pages/contracts_and_schedule/active_contracts_vm.dart';

class ActiveContractsView extends StatefulWidget {
  const ActiveContractsView({super.key});

  @override
  State<ActiveContractsView> createState() => _ActiveContractsViewState();
}

class _ActiveContractsViewState extends State<ActiveContractsView> {
  late ActiveContractsVM vm;

  @override
  void initState() {
    super.initState();
    vm = ActiveContractsVM(context: context, update: setState);
  }

  @override
  Widget build(BuildContext context) {
    return FutureLoader(
      future: vm.loadRequest,
      completeView: (context, data) {
        var data = vm.contracts;
        if (data.isEmpty) {
          return const Center(
            child: Text("Активных контрактов нет"),
          );
        }
        return ListView.separated(
          padding: EdgeInsets.zero,
          itemCount: vm.contracts.length,
          itemBuilder: (context, index) {
            var item = vm.contracts[index];
            return buildItem(item);
          },
          separatorBuilder: (context, index) {
            return const SizedBox(height: 20);
          },
        );
      },
      errorView: (context, error) => ErrorView(errorText: error.toString()),
    );
  }

  Widget buildItem(ActiveContractsModel item) {
    var rand = rnd;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
          boxShadow: const [BoxShadow(blurRadius: 8, color: Colors.black12)]),
      child: Column(children: [
        Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(children: [
                Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: SizedBox(
                        height: 68,
                        width: 68,
                        child: ProfileImage(url: item.avatar, radius: 100))),
                const SizedBox(width: 12),
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(item.name,
                      style: NannyTextStyles.nw600.copyWith(fontSize: 16)),
                  Text(item.childCountStr,
                      style: NannyTextStyles.nw600
                          .copyWith(fontSize: 12, color: Colors.grey[400]))
                ])
              ]),
              Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                      color: NannyTheme.lightGreen,
                      borderRadius: BorderRadius.circular(22)),
                  child: Text(item.type,
                      style: NannyTextStyles.nw40018
                          .copyWith(fontSize: 14, fontWeight: FontWeight.w300)))
            ]),
        const SizedBox(height: 10),
        SizedBox(
            height: 68,
            child: ListView.separated(
                padding: EdgeInsets.symmetric(vertical: 4),
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  var schedule = item.schedules[index];
                  return scheduleItem(schedule);
                },
                separatorBuilder: (context, index) {
                  return const SizedBox(width: 8);
                },
                itemCount: item.schedules.length)),
        const SizedBox(height: 12),
        Column(
            children: item.actions.map((e) {
          print('rand $rand $e');
          var isActionIndex = item.actions.indexOf(e) == rand;
          return Row(children: [
            Container(
                height: 12,
                width: 12,
                decoration: BoxDecoration(
                    color: isActionIndex ? Colors.white : NannyTheme.primary,
                    shape: BoxShape.circle,
                    border: isActionIndex
                        ? Border.all(color: NannyTheme.primary, width: 1)
                        : null)),
            const SizedBox(width: 10),
            Text(e,
                style: NannyTextStyles.nw40018
                    .copyWith(fontSize: 16, color: Colors.black))
          ]);
        }).toList()),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Стоимость одного маршрута: ",
                style: NannyTextStyles.defaultTextStyle
                    .copyWith(fontSize: 12, fontWeight: FontWeight.w400)),
            Text('${item.price}₽',
                style: NannyTextStyles.defaultTextStyle
                    .copyWith(fontSize: 16, fontWeight: FontWeight.w400))
          ],
        ),
        const SizedBox(height: 6),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Общая стоимость: ",
                style: NannyTextStyles.defaultTextStyle.copyWith(fontSize: 18)),
            Text('${item.wholePrice}₽',
                style: NannyTextStyles.defaultTextStyle
                    .copyWith(fontSize: 25, fontWeight: FontWeight.w700)),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
                child: ElevatedButton(
                    onPressed: () {}, child: Text('Редактировать'))),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
                child: CupertinoButton(
                    onPressed: () {},
                    child: Text(
                      'Отказаться',
                      style: NannyTextStyles.nw600.copyWith(fontSize: 16, color: Colors.grey[600]),
                    ))),
          ],
        ),
        const SizedBox(height: 12)
      ]),
    );
  }

  int get rnd => Random().nextInt(2);

  Widget scheduleItem(DateTime date) {
    var next = DateFormat("HH:mm").format(date.add(const Duration(hours: 2)));
    return Container(
        height: 60,
        margin: const EdgeInsets.only(left: 6),
        decoration: const BoxDecoration(
            boxShadow: [
              BoxShadow(
                  blurRadius: 8, offset: Offset(2, 2), color: Colors.black12)
            ],
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(12))),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text(NannyWeekday.values[date.weekday - 1].fullName),
          Text("${DateFormat("HH:mm").format(date)} - $next")
        ]));
  }
}
