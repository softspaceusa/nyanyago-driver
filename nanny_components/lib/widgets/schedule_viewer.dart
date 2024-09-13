import 'package:flutter/material.dart';
import 'package:nanny_components/nanny_components.dart';
import 'package:nanny_core/constants.dart';
import 'package:nanny_core/models/from_api/drive_and_map/schedule.dart';

class ScheduleViewer extends StatelessWidget {
  final NannyWeekday selectedWeedkay;
  final Schedule? schedule;
  final bool hasCheckBox;
  final List<int> selectedRoads;
  final void Function(Road road)? onRoadLongPress;
  final void Function(int id, bool selected)? roadSelected;

  const ScheduleViewer({
    super.key,
    required this.schedule,
    required this.selectedWeedkay,
    this.onRoadLongPress,

    this.hasCheckBox = false,
    this.selectedRoads = const [],
    this.roadSelected,
  });

  @override
  Widget build(BuildContext context) {
    return schedule == null ? const SizedBox() : Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(schedule!.title, style: Theme.of(context).textTheme.headlineSmall),
        const Divider(color: NannyTheme.primary, indent: 10, endIndent: 10, thickness: 2),
        const SizedBox(height: 20),
        ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.all(10),
          children: buildRoadTiles(),
        ),
      ],
    );
  }

  List<Widget> buildRoadTiles() {
    List<Widget> roadTiles = [];

    for(var road in schedule!.roads) {
      if(road.weekDay != selectedWeedkay) continue;

      roadTiles.add(
        Card(
          clipBehavior: Clip.antiAlias,
          child: GestureDetector(
            onLongPress: () => onRoadLongPress?.call(road),
            child: ExpansionTile(
              shape: NannyTheme.roundBorder,
              title: Text("${road.startTime.formatTime()} - ${road.endTime.formatTime()}"),
              trailing: hasCheckBox ? Checkbox(
                activeColor: NannyTheme.primary,
          
                value: selectedRoads.contains(road.id), 
                onChanged: (value) => roadSelected?.call(road.id!, value!),
              ) : Text(road.title),
              children: road.addresses.map(
                (e) => Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    children: [
                      Text(e.fromAddress.address),
                      Container(
                        width: 2,
                        height: 15,
                        decoration: BoxDecoration(
                          color: NannyTheme.primary,
                          borderRadius: BorderRadius.circular(20)
                        ),
                      ),
                      Text(e.toAddress.address),
                      const Divider(color: NannyTheme.primary, indent: 10, endIndent: 10)
                    ],
                  ),
                )
              ).toList(),
            ),
          ),
        )
      );
    }

    return roadTiles;
  }
}