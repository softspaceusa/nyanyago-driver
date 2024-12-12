import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nanny_components/nanny_components.dart';

class MonthSelector extends StatefulWidget {
  final void Function(int month) onMonthChanged;
  final DateTime selectedMonth;

  const MonthSelector({
    super.key,
    required this.onMonthChanged,
    required this.selectedMonth,
  });

  @override
  State<MonthSelector> createState() => _MonthSelectorState();
}

class _MonthSelectorState extends State<MonthSelector> {
  late DateTime currentMonth;

  @override
  void initState() {
    super.initState();
    currentMonth = _formatDate(DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    final isNextMonthDisabled =
        widget.selectedMonth.isAtSameMomentAs(currentMonth);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Flexible(
          flex: 1,
          child: SizedBox(
            width: 80,
            child: ElevatedButton(
              style: NannyButtonStyles.transparent,
              onPressed: () => changeMonth(-1),
              child: const Icon(Icons.arrow_back_ios_new_rounded,
                  color: NannyTheme.primary, size: 20),
            ),
          ),
        ),
        Flexible(
          flex: 3,
          child: Column(
            children: [
              Text(
                toBeginningOfSentenceCase(DateFormat('MMMM', 'ru')
                        .format(widget.selectedMonth)) ??
                    '',
                style: const TextStyle(
                  fontSize: 16,
                  height: 17.6 / 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF2B2B2B),
                ),
              ),
              if (widget.selectedMonth.year != currentMonth.year)
                Text(
                  widget.selectedMonth.year.toString(),
                  style: const TextStyle(
                    fontSize: 14,
                    height: 16 / 14,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF6A6A6A),
                  ),
                ),
            ],
          ),
        ),
        Flexible(
          flex: 1,
          child: SizedBox(
            width: 80,
            child: isNextMonthDisabled
                ? const SizedBox.shrink()
                : ElevatedButton(
                    style: NannyButtonStyles.transparent,
                    onPressed: () => changeMonth(1),
                    child: const Icon(Icons.arrow_forward_ios_rounded,
                        color: NannyTheme.primary, size: 20),
                  ),
          ),
        ),
      ],
    );
  }

  void changeMonth(int increment) => setState(() {
        widget.onMonthChanged(widget.selectedMonth.month + increment);
      });

  DateTime _formatDate(DateTime date) => DateTime(date.year, date.month);
}
