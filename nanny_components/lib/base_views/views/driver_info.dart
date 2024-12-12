import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
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

  const DriverInfoView(
      {super.key,
      required this.id,
      this.hasPaymentButtons = false,
      this.franchiseView = false,
      this.viewingOrder = false,
      this.scheduleData});

  @override
  State<DriverInfoView> createState() => _DriverInfoViewState();
}

class _DriverInfoViewState extends State<DriverInfoView> {
  late DriverInfoVM vm;

  @override
  void initState() {
    super.initState();
    vm = DriverInfoVM(
        context: context,
        update: setState,
        id: widget.id,
        viewingOrder: widget.viewingOrder,
        scheduleData: widget.scheduleData);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      appBar: const NannyAppBar(
        title: "Профиль",
        isTransparent: false,
        color: NannyTheme.secondary,
      ),
      body: RequestLoader(
        request: vm.getDriver,
        completeView: (context, data) {
          data!.userData = data.userData.asDriver();

          return Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
                child: Row(
                  children: [
                    ProfileImage(
                        url: data.userData.photoPath,
                        radius: 77,
                        padding: EdgeInsets.zero),
                    const SizedBox(width: 29),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "${data.userData.name} ${data.userData.surname}",
                          style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              height: 20 / 18,
                              color: NannyTheme.onSecondary),
                        ),
                        if (data.userData.videoPath.isNotEmpty)
                          TextButton(
                            style: const ButtonStyle(
                                padding:
                                    WidgetStatePropertyAll(EdgeInsets.zero)),
                            onPressed: () => vm.navigateToView(
                              VideoView(url: data.userData.videoPath),
                            ),
                            child: const Row(
                              children: [
                                Icon(
                                  Icons.play_circle_outline_outlined,
                                  color: Color(0xFF6D6D6D),
                                ),
                                SizedBox(width: 3),
                                Text(
                                  "Видео-описание",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                    height: 17.6 / 16,
                                    color: Color(0xFF6D6D6D),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        //RichText(
                        //  text: TextSpan(
                        //    children: [
                        //      const TextSpan(
                        //        text: "ИНН: ",
                        //        style: TextStyle(
                        //            fontSize: 16,
                        //            fontWeight: FontWeight.w400,
                        //            height: 17.6 / 16,
                        //            color: NannyTheme.onSecondary),
                        //      ),
                        //      TextSpan(
                        //        text: data.userData.roleData?.inn ?? "Пусто",
                        //        style: const TextStyle(
                        //            fontSize: 16,
                        //            fontWeight: FontWeight.w400,
                        //            height: 17.6 / 16,
                        //            color: NannyTheme.primary),
                        //      )
                        //    ],
                        //  ),
                        //)
                      ],
                    )
                  ],
                ),
              ),
              if (widget.hasPaymentButtons)
                Padding(
                  padding:
                      const EdgeInsets.only(bottom: 32, right: 20, left: 20),
                  child: Column(
                    children: [
                      PanelButton(
                        data: PanelButtonData(
                          label: 'Управление заказами',
                          imgPath: "taxi.png",
                          nextView: const SizedBox(),
                        ),
                        imageHeigh: null,
                        imageWidth: null,
                        style: NannyButtonStyles.whiteButton,
                        onPressed: () => vm.navigateToView(
                          const DriverOrdersView(),
                        ),
                      ),

                      //const SizedBox(height: 20),
                      //Row(
                      //  children: [
                      //    const SizedBox(width: 10),
                      //    Expanded(
                      //      child: ElevatedButton(
                      //          onPressed: () => vm.navigateToView(
                      //                const WalletView(
                      //                  title: "Выплата заработной платы",
                      //                  subtitle: "Выберите способ оплаты",
                      //                  hasReplenishButtons: false,
                      //                ),
                      //              ),
                      //          child: const Text("Сделать выплату")),
                      //    ),
                      //    const SizedBox(width: 10),
                      //    Expanded(
                      //      child: ElevatedButton(
                      //          onPressed: () =>
                      //              vm.navigateToView(const WalletView(
                      //                title: "Выплата заработной платы",
                      //                subtitle: "Выберите способ оплаты",
                      //                hasReplenishButtons: false,
                      //              )),
                      //          style: NannyButtonStyles.whiteButton,
                      //          child: const Text("Получить процент")),
                      //    ),
                      //    const SizedBox(width: 10),
                      //  ],
                      //)
                    ],
                  ),
                ),
              Expanded(
                child: NannyBottomSheet(
                  child: !widget.franchiseView
                      ? Column(
                          children: [
                            Expanded(
                              child: ListView(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 35, horizontal: 20),
                                shrinkWrap: true,
                                children: [
                                  const Text("Информация об авто",
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600,
                                          height: 20 / 18,
                                          color: NannyTheme.onSecondary),
                                      textAlign: TextAlign.left),
                                  const SizedBox(height: 30),
                                  carInfoPlate(
                                      title: "Марка",
                                      value: data.carDataText.autoMark),
                                  const SizedBox(height: 10),
                                  carInfoPlate(
                                      title: "Модель",
                                      value: data.carDataText.autoModel),
                                  const SizedBox(height: 10),
                                  carInfoPlate(
                                      title: "Цвет",
                                      value: data.carDataText.autoColor),
                                  const SizedBox(height: 10),
                                  carInfoPlate(
                                      title: "Год выпуска",
                                      value: data.carDataText.releaseYear
                                          .toString()),
                                  const SizedBox(height: 10),
                                  carInfoPlate(
                                      title: "Гос номер",
                                      value: data.carDataText.stateNumber),
                                  const SizedBox(height: 10),
                                  carInfoPlate(
                                      title: "СТС",
                                      value: data.carDataText.ctc),
                                ],
                              ),
                            ),
                            if (widget.viewingOrder) const SizedBox(height: 20),
                            if (widget.viewingOrder)
                              Row(
                                children: [
                                  Expanded(
                                    child: ElevatedButton(
                                        onPressed: () =>
                                            vm.answerSchedule(confirm: false),
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                Colors.red.shade400),
                                        child: const Text("Отклонить заявку")),
                                  ),
                                  const SizedBox(width: 20),
                                  Expanded(
                                    child: ElevatedButton(
                                        onPressed: () =>
                                            vm.answerSchedule(confirm: true),
                                        style: NannyButtonStyles.lightGreen,
                                        child: const Text("Одобрить заявку")),
                                  ),
                                ],
                              ),
                          ],
                        )
                      : ListView(
                          shrinkWrap: true,
                          padding: EdgeInsets.zero,
                          children: [
                            ExpansionTile(
                              initiallyExpanded: true,
                              childrenPadding: const EdgeInsets.only(
                                  left: 16, right: 16, top: 27, bottom: 27),
                              title: infoText("Информация об авто"),
                              children: [
                                carInfoPlate(
                                    title: "Марка",
                                    value: data.carDataText.autoMark),
                                const SizedBox(height: 10),
                                carInfoPlate(
                                    title: "Модель",
                                    value: data.carDataText.autoModel),
                                const SizedBox(height: 10),
                                carInfoPlate(
                                    title: "Цвет",
                                    value: data.carDataText.autoColor),
                                const SizedBox(height: 10),
                                carInfoPlate(
                                    title: "Год выпуска",
                                    value: data.carDataText.releaseYear
                                        .toString()),
                                const SizedBox(height: 10),
                                carInfoPlate(
                                    title: "Гос номер",
                                    value: data.carDataText.stateNumber),
                                const SizedBox(height: 10),
                                carInfoPlate(
                                    title: "СТС", value: data.carDataText.ctc),
                              ],
                            ),
                            //const SizedBox(
                            //  height: 42,
                            //  child: Divider(
                            //    height: 1,
                            //    color: Color(0xFFE1E1E1),
                            //  ),
                            //),
                            //ExpansionTile(
                            //  childrenPadding: const EdgeInsets.only(
                            //      left: 16, right: 16, top: 27, bottom: 27),
                            //  title: infoText("Выплата заработной платы"),
                            //  children: [
                            //    ElevatedButton(
                            //      onPressed: () {},
                            //      style: const ButtonStyle(
                            //        padding: WidgetStatePropertyAll(
                            //          EdgeInsets.all(10),
                            //        ),
                            //        shape: WidgetStatePropertyAll(
                            //          RoundedRectangleBorder(
                            //            borderRadius: BorderRadius.all(
                            //              Radius.circular(8),
                            //            ),
                            //          ),
                            //        ),
                            //        minimumSize: WidgetStatePropertyAll(
                            //          Size(double.infinity, 42),
                            //        ),
                            //      ),
                            //      child: const Text("Сделать выплату"),
                            //    ),
                            //  ],
                            //),
                            //const SizedBox(
                            //  height: 42,
                            //  child: Divider(
                            //    height: 1,
                            //    color: Color(0xFFE1E1E1),
                            //  ),
                            //),
                            //ExpansionTile(
                            //  childrenPadding: const EdgeInsets.only(
                            //      left: 16, right: 16, top: 27, bottom: 27),
                            //  title: infoText("Начисление бонусов и комиссий"),
                            //  children: [
                            //    Column(
                            //      children: [
                            //        NannyTextForm(
                            //          labelText: "Бонусы",
                            //          formatters: [
                            //            FilteringTextInputFormatter.digitsOnly
                            //          ],
                            //          keyType: TextInputType.number,
                            //          onChanged: (text) =>
                            //              vm.bonusAmount = int.parse(text),
                            //        ),
                            //        TextButton(
                            //            onPressed: vm.addBonus,
                            //            child: const Text("Готово")),
                            //        const SizedBox(height: 20),
                            //        NannyTextForm(
                            //          labelText: "Комиссии",
                            //          formatters: [
                            //            FilteringTextInputFormatter.digitsOnly
                            //          ],
                            //          keyType: TextInputType.number,
                            //          onChanged: (text) =>
                            //              vm.fineAmount = int.parse(text),
                            //        ),
                            //        TextButton(
                            //            onPressed: vm.addFines,
                            //            child: const Text("Готово")),
                            //      ],
                            //    )
                            //  ],
                            //),
                            //const SizedBox(
                            //  height: 42,
                            //  child: Divider(
                            //    height: 1,
                            //    color: Color(0xFFE1E1E1),
                            //  ),
                            //),
                            //ExpansionTile(
                            //  childrenPadding: const EdgeInsets.only(
                            //      left: 16, right: 16, top: 27, bottom: 27),
                            //  title: infoText("Просмотр бухгалтерских отчетов"),
                            //  children: const [],
                            //)
                          ],
                        ),
                ),
              ),
            ],
          );
        },
        errorView: (context, error) => ErrorView(errorText: error.toString()),
      ),
    );
  }

  Widget infoText(String text) => Text(text,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        height: 20 / 18,
        color: Color(0xFF2B2B2B),
      ),
      textAlign: TextAlign.left);

  Widget carInfoPlate({
    required String title,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      width: double.maxFinite,
      decoration: BoxDecoration(
          color: NannyTheme.secondary,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              offset: const Offset(0, 4),
              blurRadius: 14,
              color: const Color(0xFF021C3B).withOpacity(.1),
            ),
          ]),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              height: 17.6 / 16,
              color: Color(0xFF6D6D6D),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                height: 20 / 18,
                color: NannyTheme.primary),
          ),
        ],
      ),
    );
  }
}
