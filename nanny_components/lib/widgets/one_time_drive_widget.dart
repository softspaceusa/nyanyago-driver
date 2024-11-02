import 'package:flutter/material.dart';
import 'package:nanny_components/nanny_components.dart';

class OneTimeDriveWidget extends StatelessWidget {
  final OneTimeDriveModel model;
  final OneTimeDriveCallback callback;
  final bool selected;

  const OneTimeDriveWidget(this.model, this.callback, this.selected,
      {super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => callback(model.orderId),
        child: Container(
            margin: const EdgeInsets.symmetric(vertical: 5),
            decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                      color: NannyTheme.primary.withOpacity(0.3),
                      blurRadius: 10,
                      spreadRadius: 0)
                ],
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: selected
                    ? Border.all(color: NannyTheme.primary, width: 1)
                    : null),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 28),
            child: Column(children: [
              Row(children: [
                SizedBox(
                    height: 60,
                    width: 60,
                    child: ProfileImage(url: model.avatar, radius: 100)),
                const SizedBox(width: 12),
                Text(model.username,
                    style: NannyTextStyles.defaultTextStyle
                        .copyWith(fontWeight: FontWeight.w700, fontSize: 16))
              ]),
              const SizedBox(height: 32),
              ListView.separated(
                  shrinkWrap: true,
                  itemCount: model.addresses.length,
                  itemBuilder: (context, index) {
                    var item = model.addresses[index];
                    return Row(children: [
                      Container(
                          height: 12,
                          width: 12,
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          decoration: BoxDecoration(
                              color: model.addresses.indexOf(item) == 0
                                  ? NannyTheme.primary
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(100),
                              border: Border.all(
                                  color: NannyTheme.primary, width: 2))),
                      const SizedBox(width: 12),
                      Expanded(
                          child: Text(index == 0 ? item.from : item.to,
                              maxLines: null,
                              style: NannyTextStyles.defaultTextStyle.copyWith(
                                  fontWeight:
                                      index == 0 ? FontWeight.w700 : null,
                                  fontSize: 14)))
                    ]);
                  },
                  separatorBuilder: (context, index) {
                    return const SizedBox(
                        width: double.infinity,
                        height: 16,
                        child: Center(child: Divider()));
                  }),
              const SizedBox(height: 24),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text('Общая стоимость',
                    style: NannyTextStyles.defaultTextStyle
                        .copyWith(fontSize: 18)),
                Text(model.price,
                    style: NannyTextStyles.defaultTextStyle
                        .copyWith(fontSize: 25, fontWeight: FontWeight.w700))
              ])
            ])));
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
