import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nanny_components/dialogs/loading.dart';
import 'package:nanny_components/nanny_components.dart';
import 'package:nanny_core/api/nanny_franchise_api.dart';
import 'package:nanny_core/models/from_api/drive_and_map/drive_tariff.dart';
import 'package:nanny_core/models/from_api/drive_and_map/franchise_tariff.dart';
import 'package:nanny_core/nanny_core.dart';

class TariffsVM extends ViewModelBase {
  TariffsVM({
    required super.context, 
    required super.update
  });

  Future< ApiResponse<List<DriveTariff>> > request = NannyStaticDataApi.getTariffs();
  
  void reloadView() {
    request = NannyStaticDataApi.getTariffs();
    update(() {});
  }

  Future<String?> pickPhoto() async {
    ImagePicker imgPick = ImagePicker();
    var img = await imgPick.pickImage(source: ImageSource.gallery);

    if(img == null) return null;

    var uploadRes = await NannyFilesApi.uploadFiles([img]);

    if(!context.mounted) return null;
    if(!uploadRes.success) {
      NannyDialogs.showMessageBox(context, "Ошибка", "Не удалось выложить фото! Попробуйте ещё раз");
      return null;
    }

    return uploadRes.response!.paths.first;
  }

  void addTariff() async {
    String title = "";
    String photoPath = "";
    double amount = 0;
    
    bool confirm = await NannyDialogs.showModalDialog(
      context: context, 
      title: "Создание тарифа",
      child: StatefulBuilder(
        builder: (context, setState) {
          return Column(
            children: [
              NannyTextForm(
                labelText: "Название",
                hintText: "Название",
                onChanged: (text) => title = text,
              ),
              const SizedBox(height: 10),
              NannyTextForm(
                labelText: "Стоимость",
                hintText: "Стоимость",
                keyType: TextInputType.number,
                formatters: [FilteringTextInputFormatter.digitsOnly],
                onChanged: (text) => amount = double.parse(text),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () async {
                  photoPath = await pickPhoto() ?? "";
                  setState(() {});
                }, 
                child: photoPath.isEmpty ? const Text("Выберите фото") : Padding(
                  padding: const EdgeInsets.all(10),
                  child: SizedBox(
                    height: 150,
                    child: NetImage(url: photoPath, radius: 5, fitToShortest: false)
                  ),
                )
              ),
              const SizedBox(height: 20),
            ],
          );
        }
      ),
    );

    if(!confirm) return;
    if(!context.mounted) return;

    if(title.isEmpty || amount < 1) {
      NannyDialogs.showMessageBox(context, "Ошибка", "Не все данные были заполнены!");
      return;
    }

    LoadScreen.showLoad(context, true);

    bool success = await DioRequest.handleRequest(
      context, 
      NannyFranchiseApi.createTariff(
        FranchiseTariff(
          title: title,
          amount: amount,
        )
      )
    );

    if(!success) return;
    if(!context.mounted) return;

    LoadScreen.showLoad(context, false);
    NannyDialogs.showMessageBox(context, "Успех", "Тариф создан");
    reloadView();
  }

  void editTariff(DriveTariff tariff) async {
    String title = tariff.title!;
    double amount = tariff.amount!;
    
    bool confirm = await NannyDialogs.showModalDialog(
      context: context, 
      title: "Изменение тарифа",
      child: Column(
        children: [
          NannyTextForm(
            labelText: "Название",
            hintText: "Название",
            initialValue: title,
            onChanged: (text) => title = text,
          ),
          const SizedBox(height: 10),
          NannyTextForm(
            labelText: "Стоимость",
            hintText: "Стоимость",
            initialValue: amount.toString(),
            keyType: TextInputType.number,
            formatters: [FilteringTextInputFormatter.digitsOnly],
            onChanged: (text) => amount = double.parse(text),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );

    if(!confirm) return;
    if(!context.mounted) return;

    LoadScreen.showLoad(context, true);

    bool success = await DioRequest.handleRequest(
      context, 
      NannyFranchiseApi.updateTariff(
        FranchiseTariff(
          id: tariff.id,
          title: title,
          amount: amount,
        )
      )
    );

    if(!success) return;
    if(!context.mounted) return;

    LoadScreen.showLoad(context, false);
    NannyDialogs.showMessageBox(context, "Успех", "Тариф изменен");
    reloadView();
  }

  void deleteTariff(int id) async {
    bool confirm = await NannyDialogs.confirmAction(context, "Удалить тариф?");
    if(!confirm) return;
    if(!context.mounted) return;

    LoadScreen.showLoad(context, true);

    bool success = await DioRequest.handleRequest(
      context, 
      NannyFranchiseApi.deleteTariff(id)
    );

    if(!context.mounted) return;
    if(!success) {
      NannyDialogs.showMessageBox(context, "Ошибка", "Не удалось удалить тариф!");
      return;
    }

    LoadScreen.showLoad(context, false);
    NannyDialogs.showMessageBox(context, "Успех", "Тариф удален");
    reloadView();
  }
}
