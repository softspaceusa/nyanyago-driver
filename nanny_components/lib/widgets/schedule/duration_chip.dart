import 'package:flutter/material.dart';
import 'package:nanny_components/styles/nanny_theme.dart';

class DurationChip extends StatelessWidget {
  const DurationChip({super.key, required this.duration});

  final int duration;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: NannyTheme.lightGreen),
          child: Text(
            duration == 365
                ? 'Годовой'
                : duration == 30
                    ? 'Месячный'
                    : duration == 7
                        ? 'Недельный'
                        : 'N/A',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: Color(0xFF2B2B2B),
            ),
          ),
        ),
      ],
    );
  }
}
