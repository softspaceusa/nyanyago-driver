import 'package:flutter/material.dart';
import 'package:nanny_components/nanny_components.dart';
import 'package:nanny_driver/franchise/view_models/driver_management/tariffs_vm.dart';

class TarifsView extends StatefulWidget {
  const TarifsView({super.key});

  @override
  State<TarifsView> createState() => _TarifsViewState();
}

class _TarifsViewState extends State<TarifsView> with AutomaticKeepAliveClientMixin {
  late TariffsVM vm;

  @override
  void initState() {
    super.initState();
    vm = TariffsVM(context: context, update: setState);
  }
  
  @override
  Widget build(BuildContext context) {
    super.build(context);
    
    return RequestLoader(
      request: vm.request,
      completeView: (context, data) {
        if(data == null || data.isEmpty) {
          return const Center(child: Text("На данный момент тарифов нет..."));
        }

        return RefreshIndicator(
          onRefresh: () async => vm.reloadView(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: ListView(
                  shrinkWrap: true,
                  children: data.map(
                    (e) => Slidable(
                      endActionPane: ActionPane(
                        motion: const DrawerMotion(),
                        children: [
                          SlidableAction(
                            onPressed: (context) => vm.deleteTariff(e.id),
                            icon: Icons.delete,
                            label: "Удалить",
                            backgroundColor: Colors.red,
                          )
                        ]
                      ),
                      child: ListTile(
                        title: Text(e.title!),
                        subtitle: Text("~${e.amount} рублей"),
                      
                        onTap: () => vm.editTariff(e),
                      ),
                    )
                  ).toList(),
                ),
              ),
              NannyBottomSheet(
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    children: [
                      FloatingActionButton(
                        onPressed: vm.addTariff,
                        child: const Icon(Icons.add),
                      ),
                      const Text("Добавить тариф")
                    ],
                  ),
                ),
              )
            ],
          ),
        );
      },
      errorView: (context, error) => ErrorView(errorText: error.toString()),
    );
  }
  
  @override
  bool get wantKeepAlive => true;
}