import 'package:flutter/material.dart';
import 'package:nanny_components/nanny_components.dart';
import 'package:nanny_driver/franchise/view_models/partner/my_referals_vm.dart';

class MyReferalsView extends StatefulWidget {
  const MyReferalsView({super.key});

  @override
  State<MyReferalsView> createState() => _MyReferalsViewState();
}

class _MyReferalsViewState extends State<MyReferalsView> {
  late MyReferalsVM vm;
  
  @override
  void initState() {
    super.initState();
    vm = MyReferalsVM(context: context, update: setState);
  }
  
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: const NannyAppBar(
          title: "Рефералы",
        ),
        body: RequestLoader(
          request: vm.request, 
          completeView: (context, data) => Column(
            children: [

              Row(
                children: [
                  Expanded(
                    child: textInfo(
                      title: "Общий баланс:", 
                      subtitle: data!.allIncoming.toString()
                    )
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: textInfo(
                      title: "Вы получите:", 
                      subtitle: data.getPercent.toString()
                    )
                  ),
                ],
              ),
              Expanded(
                child: ListView(
                  shrinkWrap: true,
                  children: data.referals.map(
                    (e) => ListTile(
                      isThreeLine: true,
                      leading: ProfileImage(
                        url: e.photoPath, 
                        radius: 30
                      ),
                      title: Text("${e.name} ${e.surname}"),
                      subtitle: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text("Присоединился ${e.dateReg}", style: TextStyle(color: NannyTheme.onSecondary.withAlpha(150))),
                          const SizedBox(height: 5),
                          RichText(
                            text: TextSpan(
                              children: [
                                const TextSpan(
                                  text: "Всего заработано",
                                  style: TextStyle(color: NannyTheme.primary)
                                ),
                                TextSpan(
                                  text: e.roleData!.allIncoming.toString()
                                ),
                              ]
                            )
                          ),
                          RichText(
                            text: TextSpan(
                              children: [
                                const TextSpan(
                                  text: "Вы получите (% от суммы) ",
                                  style: TextStyle(color: NannyTheme.primary)
                                ),
                                TextSpan(
                                  text: e.roleData!.getPercent.toString()
                                ),
                              ]
                            )
                          ),
                        ],
                      ),
                    )
                  ).toList(),
                )
              )
              
            ],
          ), 
          errorView: (context, error) => ErrorView(errorText: error.toString()),
        ),
      ),
    );
  }

  Widget textInfo({
    required String title,
    required String subtitle,
  }) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
          Text(title),
          Text(subtitle, style: Theme.of(context).textTheme.headlineSmall),
      ],
    );
  }
}