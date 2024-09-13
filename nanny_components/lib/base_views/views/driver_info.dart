import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nanny_components/base_views/view_models/driver_info_vm.dart';
import 'package:nanny_components/base_views/views/driver_orders.dart';
import 'package:nanny_components/base_views/views/video_view.dart';
import 'package:nanny_components/nanny_components.dart';
import 'package:nanny_core/models/from_api/drive_and_map/schedule_responses_data.dart';


/// Используется для просмотра данных профиля водителя.
/// 
/// Если стоит флаг [viewingOrder], то [scheduleData] НЕ должно быть пустым
class DriverInfoView extends StatefulWidget {
  final int id;
  final bool hasPaymentButtons;
  final bool franchiseView;
  final bool viewingOrder;
  final ScheduleResponsesData? scheduleData;
  
  const DriverInfoView({
    super.key,
    required this.id,
    this.hasPaymentButtons = false,
    this.franchiseView = false,
    this.viewingOrder = false,
    this.scheduleData
  });

  @override
  State<DriverInfoView> createState() => _DriverInfoViewState();
}

class _DriverInfoViewState extends State<DriverInfoView> {
  late DriverInfoVM vm;

  @override
  void initState() {
    super.initState();
    vm = DriverInfoVM(context: context, update: setState, id: widget.id, viewingOrder: widget.viewingOrder, scheduleData: widget.scheduleData);
  }
  
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: const NannyAppBar(
          title: "Профиль",
        ),
        body: RequestLoader(
          request: vm.getDriver,
          completeView: (context, data) {
            data!.userData = data.userData.asDriver();
            
            return Column(
              children: [
            
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      ProfileImage(
                        url: data.userData.photoPath, 
                        radius: 90
                      ),
                      const SizedBox(width: 10),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${data.userData.name} ${data.userData.surname}", 
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 10),
                          TextButton(
                            onPressed: data.userData.videoPath.isNotEmpty ? 
                              () => vm.navigateToView(VideoView(url: data.userData.videoPath))
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
                                TextSpan(text: data.userData.roleData?.inn ?? "Пусто", style: const TextStyle(color: NannyTheme.primary))
                              ]
                            )
                          )
                        ],
                      )
                    ],
                  ),
                ),
                if(widget.hasPaymentButtons) Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Column(
                    children: [
                      ElevatedButton.icon(
                        onPressed: () => vm.navigateToView(const DriverOrdersView()),
                        style: NannyButtonStyles.whiteButton,
                        icon: const Text("Управление заказами"),
                        label: Image.asset("packages/nanny_components/assets/images/taxi.png"),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          const SizedBox(width: 10),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () => vm.navigateToView(
                                WalletView(
                                  title: "Выплата заработной платы",
                                  subtitle: "Выберите способ оплаты",
                                  hasReplenishButtons: false,
                                )
                              ), 
                              child: const Text("Сделать выплату")
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () => vm.navigateToView(
                                WalletView(
                                  title: "Выплата заработной платы",
                                  subtitle: "Выберите способ оплаты",
                                  hasReplenishButtons: false,
                                )
                              ), 
                              style: NannyButtonStyles.whiteButton,
                              child: const Text("Получить процент")
                            ),
                          ),
                          const SizedBox(width: 10),
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
                      child: !widget.franchiseView ? Column(
                        children: [
                          Expanded(
                            child: ListView(
                              shrinkWrap: true,
                              children: [
                                Text("Информация об авто", style: Theme.of(context).textTheme.titleMedium, textAlign: TextAlign.center),
                                const SizedBox(height: 30),
                                carInfoPlate(title: "Марка", value: data.carDataText.autoMark),
                                const SizedBox(height: 10),
                                carInfoPlate(title: "Модель", value: data.carDataText.autoModel),
                                const SizedBox(height: 10),
                                carInfoPlate(title: "Цвет", value: data.carDataText.autoColor),
                                const SizedBox(height: 10),
                                carInfoPlate(title: "Год выпуска", value: data.carDataText.releaseYear.toString()),
                                const SizedBox(height: 10),
                                carInfoPlate(title: "Гос номер", value: data.carDataText.stateNumber),
                                const SizedBox(height: 10),
                                carInfoPlate(title: "СТС", value: data.carDataText.ctc),
                              ],
                            ),
                          ),
                          if(widget.viewingOrder) const SizedBox(height: 20),
                          if(widget.viewingOrder) Row(
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () => vm.answerSchedule(confirm: false), 
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red.shade400
                                  ),
                                  child: const Text("Отклонить заявку")
                                ),
                              ),
                              const SizedBox(width: 20),
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () => vm.answerSchedule(confirm: true), 
                                  style: NannyButtonStyles.lightGreen,
                                  child: const Text("Одобрить заявку")
                                ),
                              ),
                            ],
                          ),
                        ],
                      )
                      : ListView(
                        shrinkWrap: true,
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        children: [
                          ExpansionTile(
                            title: infoText("Информация об авто"),
                            children: [
                              const SizedBox(height: 30),
                              carInfoPlate(title: "Марка", value: data.carDataText.autoMark),
                              const SizedBox(height: 10),
                              carInfoPlate(title: "Модель", value: data.carDataText.autoModel),
                              const SizedBox(height: 10),
                              carInfoPlate(title: "Цвет", value: data.carDataText.autoColor),
                              const SizedBox(height: 10),
                              carInfoPlate(title: "Год выпуска", value: data.carDataText.releaseYear.toString()),
                              const SizedBox(height: 10),
                              carInfoPlate(title: "Гос номер", value: data.carDataText.stateNumber),
                              const SizedBox(height: 10),
                              carInfoPlate(title: "СТС", value: data.carDataText.ctc),
                            ]
                          ),
                          const SizedBox(height: 20),
                          ExpansionTile(
                            title: infoText("Выплата заработной платы"),
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(10),
                                child: ElevatedButton(
                                  onPressed: () {}, 
                                  child: const Text("Сделать выплату")
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          ExpansionTile(
                            title: infoText("Начисление бонусов и комиссий"),
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(10),
                                child: Column(
                                  children: [
                                    NannyTextForm(
                                      labelText: "Бонусы",
                                      formatters: [FilteringTextInputFormatter.digitsOnly],
                                      keyType: TextInputType.number,
                                      onChanged: (text) => vm.bonusAmount = int.parse(text),
                                    ),
                                    TextButton(
                                      onPressed: vm.addBonus, 
                                      child: const Text("Готово")
                                    ),
                                    const SizedBox(height: 20),
                                    NannyTextForm(
                                      labelText: "Комиссии",
                                      formatters: [FilteringTextInputFormatter.digitsOnly],
                                      keyType: TextInputType.number,
                                      onChanged: (text) => vm.fineAmount = int.parse(text),
                                    ),
                                    TextButton(
                                      onPressed: vm.addFines, 
                                      child: const Text("Готово")
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                          const SizedBox(height: 20),
                          ExpansionTile(
                            title: infoText("Просмотр бухгалтерских отчетов"),
                            children: [],
                          )
                        ],
                      ),
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