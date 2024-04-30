import 'package:flutter/material.dart';
import 'package:nanny_components/nanny_components.dart';
import 'package:nanny_driver/franchise/view_models/driver_management.dart/tariffs_vm.dart';

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

        return ListView(
          children: data.map(
            (e) => ListTile(
              title: Text(e.title!),
              subtitle: Text("~${e.amount} рублей"),
            )
          ).toList(),
        );
      },
      errorView: (context, error) => ErrorView(errorText: error.toString()),
    );
  }
  
  @override
  bool get wantKeepAlive => true;
}