import 'package:flutter/material.dart';
import 'package:nanny_components/base_views/view_models/driver_orders_vm.dart';
import 'package:nanny_components/nanny_components.dart';
import 'package:nanny_core/api/nanny_orders_api.dart';
import 'package:nanny_core/models/from_api/drive_and_map/drive_tariff.dart';
import 'package:nanny_core/models/from_api/drive_and_map/schedule.dart';
import 'package:nanny_core/models/from_api/franchise/order_model.dart';
import 'package:nanny_core/nanny_core.dart';

class DriverOrdersView extends StatefulWidget {
  const DriverOrdersView({super.key});

  @override
  State<DriverOrdersView> createState() => _DriverOrdersViewState();
}

class _DriverOrdersViewState extends State<DriverOrdersView> {
  late DriverOrdersVM vm;

  List<DropdownMenuData<String>> items = [
    DropdownMenuData(title: "Не задано", value: ""),
    DropdownMenuData(title: "Активен", value: "Активен"),
    DropdownMenuData(title: "Не активен", value: "Не активен"),
  ];

  @override
  void initState() {
    super.initState();
    vm = DriverOrdersVM(context: context, update: setState);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      appBar: const NannyAppBar(
        title: "Управление заказами",
        color: NannyTheme.secondary,
        isTransparent: false,
      ),
      body: Column(
        children: [
          //const SizedBox(height: 40),
          //Center(
          //  child: FloatingActionButton.large(
          //    onPressed: () => NannyDialogs.showRouteCreateSheet(
          //        context, NannyWeekday.monday),
          //    child: const Icon(Icons.add),
          //  ),
          //),
          //const SizedBox(height: 20),
          //const Text(
          //  "Новый заказ",
          //  style: TextStyle(
          //      fontWeight: FontWeight.w400,
          //      fontSize: 18,
          //      height: 19.8 / 18,
          //      color: NannyTheme.onSecondary),
          //),
          const SizedBox(height: 40),
          Expanded(
            child: NannyBottomSheet(
              child: RequestLoader(
                request: NannyOrdersApi.getFranchiseDriverOrders(),
                completeView: (context, data) {
                  //List<OrderModel> data = List.generate(
                  //  50,
                  //  (index) => OrderModel(
                  //      id: 1,
                  //      status: 'афафы',
                  //      name: '123',
                  //      idDriver: 1,
                  //      nameDriver: '123',
                  //      surnameDriver: '123'),
                  //);

                  if (vm.status.isNotEmpty) {
                    data = (data ?? [])
                        .where((e) =>
                            e.status.toLowerCase() == vm.status.toLowerCase())
                        .toList();
                  }

                  return Builder(
                    builder: (context) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 18),
                            child: DropdownButton(
                              elevation: 1,
                              dropdownColor: NannyTheme.secondary,
                              borderRadius: BorderRadius.circular(10),
                              padding: EdgeInsets.zero,
                              underline: Container(),
                              value: vm.query.statuses.first,
                              items: items
                                  .map((e) => DropdownMenuItem(
                                        value: e.value,
                                        child: Text(
                                          e.title,
                                          style: const TextStyle(
                                              color: NannyTheme.onSecondary,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w400,
                                              height: 1),
                                        ),
                                      ))
                                  .toList(),
                              onChanged: (value) => vm.changeFilter(value!),
                            ),
                          ),
                          Expanded(
                            child: (data ?? []).isEmpty
                                ? const Center(child: Text("Список пуст..."))
                                : ListView.separated(
                                    shrinkWrap: true,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 20, horizontal: 16),
                                    itemBuilder: (context, index) => Column(
                                          children: [
                                            if (index == 0 ||
                                                index == data!.length)
                                              const Padding(
                                                padding:
                                                    EdgeInsets.only(bottom: 12),
                                                child: Divider(
                                                    height: 1,
                                                    color: NannyTheme.grey),
                                              ),
                                            ListTile(
                                              minLeadingWidth: 0,
                                              minTileHeight: 0,
                                              minVerticalPadding: 0,
                                              contentPadding: EdgeInsets.zero,
                                              title: Text(data![index].name,
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      fontSize: 18,
                                                      height: 19.8 / 18,
                                                      color:
                                                          NannyTheme.primary),
                                                  softWrap: true),
                                              subtitle: Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 5),
                                                child: Text(
                                                  'Водитель',
                                                  style: TextStyle(
                                                      color: NannyTheme
                                                          .onSecondary
                                                          .withOpacity(.75),
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      height: 16.8 / 12),
                                                ),
                                              ),
                                              trailing: Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 5),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.end,
                                                  children: [
                                                    const Text('Статус',
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            fontSize: 18,
                                                            height: 19.8 / 18,
                                                            color: NannyTheme
                                                                .primary),
                                                        softWrap: true),
                                                    const SizedBox(height: 5),
                                                    Text(
                                                      data[index].status,
                                                      style: TextStyle(
                                                          color: NannyTheme
                                                              .onSecondary
                                                              .withOpacity(.75),
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          height: 16.8 / 12),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            if (index == data.length - 1)
                                              const Padding(
                                                padding:
                                                    EdgeInsets.only(top: 12),
                                                child: Divider(
                                                    height: 1,
                                                    color: NannyTheme.grey),
                                              ),
                                          ],
                                        ),
                                    separatorBuilder: (context, index) =>
                                        const SizedBox(
                                          height: 25,
                                          child: Divider(
                                              color: NannyTheme.grey,
                                              height: 1),
                                        ),
                                    itemCount: data!.length),
                          ),
                        ],
                      );
                    },
                  );
                },
                errorView: (context, error) =>
                    ErrorView(errorText: error.toString()),
              ),
            ),
          )
        ],
      ),
    );
  }
}
