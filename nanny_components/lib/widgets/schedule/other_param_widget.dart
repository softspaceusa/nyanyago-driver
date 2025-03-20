import 'package:flutter/material.dart';
import 'package:nanny_components/nanny_components.dart';

class OtherParamWidget extends StatelessWidget {
  const OtherParamWidget(
      {super.key, required this.isSelected, required this.param});

  final bool isSelected;
  final String param;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 48),
      child: Row(
        children: [
          Container(
            height: 12,
            width: 12,
            decoration: BoxDecoration(
              color: isSelected ? NannyTheme.primary : Colors.white,
              shape: BoxShape.circle,
              border: isSelected
                  ? null
                  : Border.all(
                      color: NannyTheme.primary,
                      width: 1,
                    ),
            ),
          ),
          const SizedBox(width: 10),
          Text(
            param,
            style: NannyTextStyles.nw40018
                .copyWith(fontSize: 16, color: Colors.black),
          )
        ],
      ),
    );
  }
}
