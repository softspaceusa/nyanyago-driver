import 'package:flutter/material.dart';
import 'package:nanny_components/nanny_components.dart';
import 'package:nanny_core/nanny_core.dart';

class DateSelector extends StatefulWidget {
  final void Function(DateTime date) onDateSelected;
  final bool showMonthSelector;

  const DateSelector({
    super.key,
    required this.onDateSelected,
    this.showMonthSelector = true,
  });

  @override
  State<DateSelector> createState() => _DateSelectorState();
}

class _DateSelectorState extends State<DateSelector> {
  @override
  void initState() {
    super.initState();

    currentDate = DateTime.now();
    selectedDate = currentDate;
  }
  
  @override
  Widget build(BuildContext context) {
    return AdaptBuilder(
      builder: (context, size) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [

            if(widget.showMonthSelector) Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Flexible(
                  flex: 1,
                  child: SizedBox(
                    width: 80,
                    child: ElevatedButton(
                      onPressed: () => changeWeek(false), 
                  
                      style: NannyButtonStyles.transparent,
                      child: const Icon(Icons.arrow_back_ios_rounded)
                    ),
                  ),
                ),
                Flexible(
                  flex: 3,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        DateFormat(DateFormat.MONTH).format(currentDate),
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      Text(
                        currentDate.year.toString(),
                      ),
                    ],
                  ),
                ),
                Flexible(
                  flex: 1,
                  child: SizedBox(
                    width: 80,
                    child: ElevatedButton(
                      onPressed: () => changeWeek(true), 
                  
                      style: NannyButtonStyles.transparent,
                      child: const Icon(Icons.arrow_forward_ios_rounded)
                    ),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: getWeekdaysBtns(size, currentDate),
            ),
            
          ],
        );
      }
    );
  }

  Widget weekdayBtn(Size size, DateTime date, bool isSelected) {
    return SizedBox(
      width: size.width * .12,
      height: size.height * .1,
      child: ElevatedButton(
        onPressed: () => selectDate(date),
        style: (isSelected ? NannyButtonStyles.defaultButtonStyle : NannyButtonStyles.whiteButton)
          .copyWith(
            padding: const MaterialStatePropertyAll(EdgeInsets.zero),
            elevation: const MaterialStatePropertyAll(5),
          ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(DateFormat(DateFormat.ABBR_WEEKDAY).format(date)),
            if(widget.showMonthSelector) Text( date.day < 10 ? "0${date.day}" : date.day.toString() ),
          ],
        ),
      ),
    );
  }

  void selectDate(DateTime date) => setState(() {
    selectedDate = date;
    widget.onDateSelected(date);
  });

  List<Widget> getWeekdaysBtns(Size size, DateTime date) {
    int daysAfterMonday = date.weekday - 1;
    DateTime start = DateTime(date.year, date.month, date.day - daysAfterMonday);
    List<Widget> btns = [];

    for(int i = 0; i < 7; i++) {
      DateTime weekdayDate = start.add(Duration(days: i));
      
      btns.add(
        weekdayBtn(
          size, 
          weekdayDate, 
          DateUtils.dateOnly(selectedDate) == DateUtils.dateOnly(weekdayDate)
        )
      );
    }
    

    return btns;
  }

  String capitalize(String text) => text[0].toUpperCase() + text.substring(1);
  void changeWeek(bool add) => setState(() => currentDate = currentDate.add(Duration(days: add ? 7 : -7)));

  late DateTime selectedDate;
  late DateTime currentDate;
}