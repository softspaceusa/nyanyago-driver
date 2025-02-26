import 'package:flutter/material.dart';
import 'package:nanny_components/nanny_components.dart';
import 'package:nanny_core/nanny_core.dart';

class OneTimeDriveWidget extends StatelessWidget {
  final OneTimeDriveModel model;
  final OneTimeDriveCallback callback;
  final bool selected;

  const OneTimeDriveWidget(this.model, this.callback, this.selected,
      {super.key});

  @override
  Widget build(BuildContext context) {
    List<String> addressesList = [];

    // Добавляем начальный адрес (from первого элемента)
    if (model.addresses.isNotEmpty) {
      addressesList.add(model.addresses.first.from);
    }

    // Добавляем промежуточные точки (from всех, кроме первого и последнего)
    if (model.addresses.length > 1) {
      for (int i = 1; i < model.addresses.length; i++) {
        addressesList.add(model.addresses[i].from);
      }
    }

    // Добавляем конечный адрес (to последнего элемента)
    if (model.addresses.isNotEmpty) {
      addressesList.add(model.addresses.last.to);
    }

    return GestureDetector(
      onTap: () => callback(model.orderId),
      child: Container(
        clipBehavior: Clip.hardEdge,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 28),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: NannyTheme.secondary,
            boxShadow: [
              BoxShadow(
                offset: const Offset(0, -2),
                blurRadius: 32,
                color: const Color(0xFF605B99).withOpacity(.19),
              ),
            ],
            border: selected
                ? Border.all(color: NannyTheme.primary, width: 1)
                : null),
        child: Column(
          children: [
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: SizedBox(
                height: 55,
                width: 55,
                child: ProfileImage(
                    url: model.avatar,
                    radius: 55 / 2,
                    padding: EdgeInsets.zero),
              ),
              title: Text(
                model.username,
                style:
                    const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
              ),
            ),
            const SizedBox(height: 32),
            ListView.separated(
              shrinkWrap: true,
              itemCount: addressesList.length,
              itemBuilder: (context, index) {
                return Row(
                  children: [
                    Container(
                      height: 12,
                      width: 12,
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      decoration: BoxDecoration(
                        color: index == 0 ? NannyTheme.primary : Colors.white,
                        borderRadius: BorderRadius.circular(100),
                        border: Border.all(color: NannyTheme.primary, width: 2),
                      ),
                    ),
                    const SizedBox(width: 17),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            addressesList[index],
                            maxLines: null,
                            style: NannyTextStyles.defaultTextStyle.copyWith(
                                fontWeight: index == 0 ? FontWeight.w600 : null,
                                fontSize: 18),
                          ),
                          if (index != 0)
                            Text(
                              "${(model.addresses[index - 1].duration ~/ 60)} мин.",
                              maxLines: null,
                              style: NannyTextStyles.defaultTextStyle.copyWith(
                                  fontWeight:
                                      index == 0 ? FontWeight.w600 : null,
                                  fontSize: 12),
                            ),
                        ],
                      ),
                    )
                  ],
                );
              },
              separatorBuilder: (context, index) {
                return Container(
                  padding: const EdgeInsets.only(top: 10, bottom: 6),
                  width: double.infinity,
                  height: 16,
                  child: const Center(
                    child: Divider(),
                  ),
                );
              },
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Общая стоимость: ",
                  style: NannyTextStyles.defaultTextStyle
                      .copyWith(fontSize: 18, fontWeight: FontWeight.w400),
                ),
                Text(
                  formatCurrency(double.tryParse(model.price) ?? 0),
                  style: NannyTextStyles.defaultTextStyle.copyWith(
                      fontSize: 25,
                      fontWeight: FontWeight.w700,
                      fontFamily: ''),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Форматирование валюты
  String formatCurrency(double value) {
    final formatter = NumberFormat("#,##0.00", "en_US");
    String formatted = formatter.format(value).replaceFirst('.', ',');
    return "$formatted ₽";
  }
}

class OneTimeDriveModel {
  final String avatar;
  final String username;
  final String price;
  final int orderId;
  final dynamic orderStatus;
  final List<OneTimeDriveAddress> addresses;
  final bool isFromSocket;

  OneTimeDriveModel(
      {required this.avatar,
      required this.username,
      this.isFromSocket = false,
      required this.price,
      required this.orderId,
      required this.orderStatus,
      required this.addresses});
}

typedef OneTimeDriveCallback = void Function(int id);

class OneTimeDriveAddress {
  final String from;
  final bool isFinish;
  final String to;
  final double fromLat;
  final double fromLon;
  final double toLat;
  final double toLon;
  final int duration;

  OneTimeDriveAddress(
      {required this.from,
      required this.isFinish,
      required this.to,
      required this.fromLat,
      required this.fromLon,
      required this.toLat,
      required this.toLon,
      required this.duration});
}
