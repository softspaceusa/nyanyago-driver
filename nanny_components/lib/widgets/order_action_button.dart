import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nanny_components/nanny_components.dart';

typedef OrderActionCallback = void Function();

class OrderActionButton extends StatelessWidget {
  final OrderActionCallback callback;
  final String title;
  final String asset;

  const OrderActionButton(
      {super.key,
      required this.callback,
      required this.title,
      required this.asset});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: callback,
          child: Container(
            height: 51,
            width: 51,
            decoration: const BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                      blurRadius: 10,
                      color: Colors.black26,
                      offset: Offset(0, 3))
                ],
                color: NannyTheme.background),
            child: Center(child: Image.asset(asset, height: 22, width: 22)),
          )),
      const SizedBox(height: 6),
      Text(title,
          style: NannyTextStyles.defaultTextStyle
              .copyWith(color: Colors.black54, fontSize: 13))
    ]);
  }
}
