import 'package:flutter/material.dart';
import 'package:nanny_components/base_views/views/video_view.dart';
import 'package:nanny_components/nanny_components.dart';
import 'package:nanny_core/models/from_api/drive_and_map/schedule_responses_data.dart';
import 'package:nanny_driver/view_models/driver_request_vm.dart';


/// Используется для просмотра данных профиля водителя.
/// 
/// Если стоит флаг [viewingOrder], то [scheduleData] НЕ должно быть пустым
class DriverRequestView extends StatefulWidget {
  final int id;
  final ScheduleResponsesData? scheduleData;
  
  const DriverRequestView({
    super.key,
    required this.id,
    this.scheduleData
  });

  @override
  State<DriverRequestView> createState() => _DriverRequestViewState();
}

class _DriverRequestViewState extends State<DriverRequestView> {
  late DriverRequestVM vm;

  @override
  void initState() {
    super.initState();
    vm = DriverRequestVM(context: context, update: setState, id: widget.id);
  }
  
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: const NannyAppBar(
          title: "Профиль",
        ),
        body: FutureLoader(
          future: vm.loadRequest,
          completeView: (context, data) {
            if(!data) return const ErrorView(errorText: "Не удалось загрузить данные");
            
            return Column(
              children: [
            
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      ProfileImage(
                        url: vm.driver.userData.photoPath, 
                        radius: 90
                      ),
                      const SizedBox(width: 10),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${vm.driver.userData.name} ${vm.driver.userData.surname}", 
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 10),
                          TextButton(
                            onPressed: vm.driver.userData.videoPath.isNotEmpty ? 
                              () => vm.navigateToView(VideoView(url: vm.driver.userData.videoPath))
                              : null, 
                            child: const Row(
                              children: [
                                Icon(Icons.play_circle_outline_outlined),
                                Text("Видео-описание"),
                              ],
                            )
                          ),
                          const SizedBox(height: 10),
                          RichText(
                            text: TextSpan(
                              children: [
                                const TextSpan(text: "ИНН: ", style: TextStyle(color: NannyTheme.onSecondary)),
                                TextSpan(text: vm.driver.userData.roleData?.inn ?? "Пусто", style: const TextStyle(color: NannyTheme.primary))
                              ]
                            )
                          )
                        ],
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                Expanded(
                  child: NannyBottomSheet(
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        children: [
                          Expanded(
                            child: ListView(
                              shrinkWrap: true,
                              children: [
                                Text("Информация об авто", style: Theme.of(context).textTheme.titleMedium, textAlign: TextAlign.center),
                                const SizedBox(height: 30),
                                carInfoPlate(title: "Марка", value: vm.driver.carDataText.autoMark),
                                const SizedBox(height: 10),
                                carInfoPlate(title: "Модель", value: vm.driver.carDataText.autoModel),
                                const SizedBox(height: 10),
                                carInfoPlate(title: "Цвет", value: vm.driver.carDataText.autoColor),
                                const SizedBox(height: 10),
                                carInfoPlate(title: "Год выпуска", value: vm.driver.carDataText.releaseYear.toString()),
                                const SizedBox(height: 10),
                                carInfoPlate(title: "Гос номер", value: vm.driver.carDataText.stateNumber),
                                const SizedBox(height: 10),
                                carInfoPlate(title: "СТС", value: vm.driver.carDataText.ctc),
                              ],
                            ),
                          ),
                          Material(
                            elevation: 10,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(Radius.circular(20))
                            ),
                            clipBehavior: Clip.antiAlias,
                            child: ExpansionTile(
                              title: const Text("Доступные тарифы"),
                              children: vm.tariffs.map(
                                (e) => CheckboxListTile(
                                  value: e.id <= vm.maxAllowedTariffId,
                                  activeColor: NannyTheme.primary,
                                  title: Text(e.title!),
                                  onChanged: (_) => vm.changeMaxTariff(e.id)
                                ),
                              ).toList(),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () => vm.answerRequest(accept: false), 
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red.shade400
                                  ),
                                  child: const Text("Отклонить")
                                ),
                              ),
                              const SizedBox(width: 20),
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () => vm.answerRequest(accept: true), 
                                  style: NannyButtonStyles.lightGreen,
                                  child: const Text("Одобрить")
                                ),
                              ),
                            ],
                          )
                        ],
                      )
                    )
                  )
                ),
            
              ],
            );
          },
          errorView: (context, error) => ErrorView(errorText: error.toString()),
        ),
      ),
    );
  }

  Widget infoText(String text) => Text(text, style: Theme.of(context).textTheme.titleMedium);

  Widget carInfoPlate({
    required String title,
    required String value,
  }) {
    return SizedBox(
      width: double.maxFinite,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: Theme.of(context).textTheme.titleMedium),
              Text(value),
            ],
          ),
        ),
      )
    );
  }
}