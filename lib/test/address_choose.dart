import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:nanny_components/nanny_components.dart';
import 'package:nanny_driver/test/address_choose_vm.dart';

class AddressChooseView extends StatefulWidget {
  final BuildContext baseContext;
  final ScrollController scrController;
  
  const AddressChooseView({
    super.key,
    required this.baseContext,
    required this.scrController,
  });

  @override
  State<AddressChooseView> createState() => _AddressChooseViewState();
}

class _AddressChooseViewState extends State<AddressChooseView> {
  late AddressChooseVM vm;

  @override
  void initState() {
    super.initState();
    vm = AddressChooseVM(context: context, update: setState, baseContext: widget.baseContext);
  }
  
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: widget.scrController,
      child: FutureLoader(
        future: vm.loadRequest, 
        completeView: (context, data) {
          if(!data) {
            return const ErrorView(errorText: "Не удалось загрузить все данные!");
          }

          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: ListView(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    children: vm.addresses.asMap().entries.map(
                      (e) => Padding(
                        padding: const EdgeInsets.all(5),
                        child: NannyTextForm(
                          controller: e.value.controller,
                          readOnly: true,
                          labelText: "Поиск адреса",
                          style: e.key != 0 && e.key != 1 ? InputDecoration(
                            suffixIcon: IconButton(
                              onPressed: () => vm.removeAddress(e.value), 
                              icon: const Icon(Icons.delete)
                            )
                          ) : null,
                          onTap: () => vm.searchAddress(e.value),
                        ),
                      ),
                    ).toList(),
                  ),
                ),
                const SizedBox(height: 10),
                FloatingActionButton(
                  onPressed: vm.addAddress,
                  child: const Icon(Icons.add),
                ),
                const SizedBox(height: 20),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Row(
                      children: vm.tariffs.map(
                        (e) => Padding(
                          padding: const EdgeInsets.all(5),
                          child: SizedBox(
                            width: 150,
                            child: ListTile(
                              tileColor: NannyTheme.primary,
                              title: Text(e.title!),
                              subtitle: Text("От ${e.amount}"),
                            ),
                          ),
                        )
                      ).toList(),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: vm.setPolyline, 
                  child: const Text("Задать маршрут")
                ),
              ],
            ),
          );
        }, 
        errorView: (context, error) => ErrorView(errorText: error.toString()),
      )
    );
  }
}