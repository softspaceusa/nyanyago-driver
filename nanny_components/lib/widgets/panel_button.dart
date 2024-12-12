import 'package:flutter/material.dart';
import 'package:nanny_components/styles/button_styles.dart';

class PanelButton extends StatelessWidget {
  const PanelButton(
      {super.key,
      required this.data,
      required this.style,
      required this.onPressed,
      this.imageHeigh = 96,
      this.imageWidth = 96});

  final PanelButtonData data;
  final ButtonStyle style;
  final Function() onPressed;
  final double? imageHeigh;
  final double? imageWidth;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 112,
      width: double.maxFinite,
      decoration: BoxDecoration(
        boxShadow: [
          if (style == NannyButtonStyles.lightGreen)
            BoxShadow(
              offset: const Offset(0, 5),
              blurRadius: 11,
              spreadRadius: -6,
              color: const Color(0xFF0D5118).withOpacity(.5),
            )
          else
            BoxShadow(
              offset: const Offset(0, 5),
              blurRadius: 7,
              color: const Color(0xFF171170).withOpacity(.1),
            )
        ],
      ),
      child: ElevatedButton(
          style: style.copyWith(
            padding: const WidgetStatePropertyAll(
              EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
            elevation: const WidgetStatePropertyAll(0),
            shape: WidgetStatePropertyAll(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          onPressed: onPressed,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 14, right: 8),
                  child: Text(
                    data.label,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      height: 20 / 18,
                      color: Color(0xFF2B2B2B),
                    ),
                  ),
                ),
              ),
              Image.asset(
                  'packages/nanny_components/assets/images/${data.imgPath}',
                  fit: BoxFit.cover,
                  width: imageWidth,
                  height: imageHeigh),
            ],
          )),
    );
  }
}

class PanelButtonData {
  PanelButtonData(
      {required this.label, required this.imgPath, required this.nextView});

  final String label;
  final String imgPath;
  final Widget nextView;
}
