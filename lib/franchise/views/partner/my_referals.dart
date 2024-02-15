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
          completeView: (context, data) => Stack(
            children: [

              Column(
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
                  const SizedBox(height: 10),
                  Expanded(
                    child: ListView(
                      shrinkWrap: true,
                      children: data.referals.asMap().entries.map(
                        (e) => ListTile(
                          isThreeLine: true,
                          leading: ProfileImage(
                            url: e.value.photoPath, 
                            radius: 50
                          ),
                          title: Text("${e.value.name} ${e.value.surname}"),
                          subtitle: Padding(
                            padding: EdgeInsets.only(
                              top: 5, 
                              bottom: e.key == data.referals.length - 1 ? 80 : 5
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  "Присоединился ${e.value.dateReg}", 
                                  style: TextStyle(color: NannyTheme.onSecondary.withAlpha(150))
                                ),
                                const SizedBox(height: 5),
                                RichText(
                                  text: TextSpan(
                                    children: [
                                      const TextSpan(
                                        text: "Всего заработано ",
                                        style: TextStyle(color: NannyTheme.primary)
                                      ),
                                      TextSpan(
                                        text: e.value.roleData!.allIncoming.toString(),
                                        style: const TextStyle(color: NannyTheme.onSecondary)
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
                                        text: e.value.roleData!.getPercent.toString(),
                                        style: const TextStyle(color: NannyTheme.onSecondary)
                                      ),
                                    ]
                                  )
                                ),
                              ],
                            ),
                          ),
                        )
                      ).toList(),
                    )
                  ),
                  
                ],
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: ElevatedButton(
                    onPressed: () => vm.navigateToView(
                      const WalletView(
                        title: "Отправить запрос", 
                        subtitle: "Выберите карту"
                      )
                    ), 
                    child: const Text("Отправить запрос")
                  ),
                ),
              ),
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
