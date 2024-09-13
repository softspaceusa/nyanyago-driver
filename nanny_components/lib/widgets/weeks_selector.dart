import 'package:flutter/material.dart';
import 'package:nanny_components/nanny_components.dart';
import 'package:nanny_core/nanny_core.dart';

class WeeksSelector extends StatefulWidget {
  final void Function(NannyWeekday weekday) onChanged;
  final NannyWeekday selectedWeekday;
  
  const WeeksSelector({
    super.key,
    required this.onChanged,
    required this.selectedWeekday,
  });

  @override
  State<WeeksSelector> createState() => _WeeksSelectorState();
}

class _WeeksSelectorState extends State<WeeksSelector> {
  @override
  Widget build(BuildContext context) {
    return AdaptBuilder(
      builder: (context, size) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: NannyWeekday.values.map(
            (e) => SizedBox(
              width: size.width * .12,
              height: size.height * .08,
              child: ElevatedButton(
                onPressed: () => widget.onChanged(e),
                style: (e == widget.selectedWeekday ? NannyButtonStyles.defaultButtonStyle
                  : NannyButtonStyles.whiteButton)
                  .copyWith(
                  padding: const MaterialStatePropertyAll(
                    EdgeInsets.all(2)
                  )
                ),
                
                child: Text(
                  e.shortName, 
                  textAlign: TextAlign.center,
                  // style: const TextStyle(fontSize: 10),
                ),
              ),
            )
          ).toList(),
        );
      }
    );
  }

}
