import 'package:flutter/material.dart';
import 'package:nanny_components/styles/button_styles.dart';
import 'package:nanny_components/styles/nanny_theme.dart';
import 'package:nanny_core/models/from_api/drive_and_map/today_schedule_data.dart';
import 'package:nanny_core/nanny_core.dart';

class TodayScheduleView extends StatelessWidget {
  final TodayScheduleData schedule;
  final VoidCallback onPressed;
  final bool isSelected;

  const TodayScheduleView({
    super.key,
    required this.schedule,
    required this.onPressed,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: NannyButtonStyles.secondary.copyWith(
        padding: const WidgetStatePropertyAll(
          EdgeInsets.all(16),
        ),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: isSelected
                  ? const BorderSide(color: NannyTheme.primary, width: 1)
                  : BorderSide.none),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                schedule.title,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                  fontFamily: 'Nunito',
                  color: Color(0xFF2B2B2B),
                ),
              ),
              Text(
                schedule.time,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                  fontFamily: 'Nunito',
                  color: Color(0xFF2B2B2B),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                schedule.parentName,
                style: const TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 16,
                  fontFamily: 'Nunito',
                  color: Color(0xFF6D6D6D),
                ),
              ),
              Text(
                DateFormat('dd.MM.yyyy').format(schedule.date),
                style: const TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 16,
                  fontFamily: 'Nunito',
                  color: Color(0xFF6D6D6D),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
