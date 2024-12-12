import 'package:flutter/material.dart';
import 'package:nanny_components/base_views/admin_part/view_models/order_management_vm.dart';
import 'package:nanny_components/nanny_components.dart';
import 'package:nanny_core/nanny_core.dart';

class OrderManagement extends StatefulWidget {
  // TODO: Изменить под заказы!
  const OrderManagement({super.key});

  @override
  State<OrderManagement> createState() => _OrderManagementState();
}

class _OrderManagementState extends State<OrderManagement> {
  late OrderManagementVM vm;

  List<DropdownMenuData<String>> items = [
    DropdownMenuData(title: "Не задано", value: ""),
    DropdownMenuData(title: "Активен", value: "Активен"),
    DropdownMenuData(title: "Не активен", value: "Не активен"),
  ];

  @override
  void initState() {
    super.initState();
    vm = OrderManagementVM(context: context, update: setState);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: const NannyAppBar(
          title: "Управление заказами",
          // bottom: PreferredSize(
          //   preferredSize: const Size.fromHeight(50),
          //   child: Align(
          //     alignment: Alignment.centerLeft,
          //     child: Padding(
          //       padding: const EdgeInsets.only(left: 10),
          //       child: DropdownButton(
          //         value: vm.query.statuses.first,
          //         items: items.map(
          //           (e) => DropdownMenuItem(
          //             value: e.value,
          //             child: Text(e.title),
          //           )
          //         ).toList(),
          //         onChanged: (value) => vm.changeFilter(value!),
          //       ),
          //     ),
          //   ),
          // ),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: NannyTextForm(
                style: NannyTextFormStyles.searchForm,
                onChanged: (text) => vm.search(text),
              ),
            ),
            Expanded(
              child: RequestLoader(
                request: vm.delayer.request,
                completeView: (context, data) {
                  if (vm.delayer.isLoading) return const LoadingView();

                  return ListView(
                    shrinkWrap: true,
                    children: data!
                        .map(
                          (e) => e.id == -1
                              ? const SizedBox()
                              : Slidable(
                                  endActionPane: ActionPane(
                                      extentRatio: .8,
                                      motion: const DrawerMotion(),
                                      children: [
                                        SlidableAction(
                                          flex: 1,
                                          onPressed: (context) =>
                                              vm.deleteOrder(e),
                                          backgroundColor: Colors.red,
                                          foregroundColor: Colors.white,
                                          icon: Icons.delete,
                                          label: "Удалить",
                                        ),
                                      ]),
                                  child: ListTile(
                                    title:
                                        const Text("e.title", softWrap: true),
                                    subtitle: Text(e.description),
                                    trailing: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Text(e.tariff.title ??
                                            "Неизвестный тариф"),
                                        Text(
                                            "Продолжительность: ${e.duration.toString()}")
                                      ],
                                    ),
                                  ),
                                ),
                        )
                        .toList(),
                  );
                },
                errorView: (context, error) =>
                    ErrorView(errorText: error.toString()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
