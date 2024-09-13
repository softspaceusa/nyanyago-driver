import 'package:flutter/material.dart';
import 'package:nanny_components/base_views/admin_part/view_models/settings/other_params_vm.dart';
import 'package:nanny_components/nanny_components.dart';
import 'package:nanny_core/models/from_api/other_parametr.dart';
import 'package:nanny_core/nanny_core.dart';

class OtherParamsSettings extends StatefulWidget {
  const OtherParamsSettings({super.key});

  @override
  State<OtherParamsSettings> createState() => _OtherParamsSettingsState();
}

class _OtherParamsSettingsState extends State<OtherParamsSettings> {
  late OtherParamsVM vm;

  @override
  void initState() {
    super.initState();
    vm = OtherParamsVM(context: context, update: setState);
  }
  
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: const NannyAppBar(
          title: "Дополнительные услуги",
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Text("Стоимость дополнительных услуг", style: Theme.of(context).textTheme.titleSmall),
                const SizedBox(height: 10),
                RequestListLoader(
                  request: NannyStaticDataApi.getOtherParams(),
                  // tileTemplate: (context, e) => ListTile(
                  //   title: Text("", style: Theme.of(context).textTheme.titleSmall),
                  //   trailing: Text(e.amount.toString(), style: const TextStyle(color: NannyTheme.primary)),
                  //   onTap: () => showParamsDialog(e),
                  // ),
                  shrinkWrap: true,
                  tileTemplate: (context, e) => Slidable(
                    endActionPane: ActionPane(
                      motion: const DrawerMotion(), 
                      children: [
                        SlidableAction(
                          onPressed: (context) => vm.paramAction(
                            NannyAdminApi.deleteOtherParametr(
                              OtherParametr(
                                id: e.id,
                              )
                            )
                          ),
                          icon: Icons.delete,
                          label: "Удалить",
                          backgroundColor: Colors.red,
                        )
                      ]
                    ),
                    child: ListTile(
                      title: Text(e.title ?? "Неизвестная услуга", style: Theme.of(context).textTheme.titleSmall),
                      trailing: Text(e.amount.toString(), style: const TextStyle(color: NannyTheme.primary)),
                      onTap: () => showParamsDialog(e),
                    ),
                  ),
                  errorView: (context, error) => ErrorView(errorText: error.toString()),
                ),
                const SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    onPressed: newParam,
                    child: const Text("Создать новую услугу")
                  ),
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }

  void showParamsDialog(OtherParametr param) async {
    String amount = "";

    await NannyDialogs.showModalDialog(
      context: context, 
      hasDefaultBtn: false,
      title: param.title,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: NannyTextForm(
          labelText: param.amount.toString(),
          onChanged: (text) => amount = text,
          keyType: TextInputType.number,
        ),
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            if(double.tryParse(amount) == null) return;
            
            vm.paramAction(
              NannyAdminApi.updateOtherParametr(
                OtherParametr(
                  id: param.id,
                  title: param.title,
                  amount: double.parse(amount),
                )
              )
            );
          },
          child: const Text("Ок")
        ),
      ]
    );
  }

  void newParam() async {
    String title = "";
    String amount = "";
    
    await NannyDialogs.showModalDialog(
      context: context, 
      hasDefaultBtn: false,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [

            NannyTextForm(
              labelText: "Название",
              onChanged: (text) => title = text,
            ),
            NannyTextForm(
              labelText: "Стоимость",
              onChanged: (text) => amount = text,
              keyType: TextInputType.number,
            ),
            
          ],
        ),
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            if(amount.isEmpty || title .isEmpty) return;

            vm.paramAction(
              NannyAdminApi.createOtherParametr(
                OtherParametr(
                  title: title,
                  amount: double.parse(amount),
                )
              )
            );
          },
          child: const Text("Создать")
        ),
      ]
    );
  }
}