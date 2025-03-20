import 'package:flutter/material.dart';
import 'package:nanny_components/nanny_components.dart';
import 'package:nanny_components/widgets/schedule/client_profile_data.dart';
import 'package:nanny_components/widgets/schedule/duration_chip.dart';
import 'package:nanny_components/widgets/schedule/other_param_widget.dart';
import 'package:nanny_core/models/from_api/drive_and_map/driver_schedule_response.dart';
import 'package:nanny_core/models/from_api/drive_and_map/schedule.dart';
import 'package:nanny_core/models/from_api/other_parametr.dart';
import 'package:nanny_core/nanny_core.dart';

class ScheduleWidget extends StatelessWidget {
  const ScheduleWidget({
    super.key,
    this.onTap,
    this.onEditSchedule,
    this.onCancelSchedule,
    required this.schedule,
    required this.allParams,
  });

  final Function()? onTap;
  final Function()? onEditSchedule;
  final Function()? onCancelSchedule;
  final DriverScheduleResponse schedule;
  final List<OtherParametr> allParams;

  @override
  Widget build(BuildContext context) {
    List<OtherParametr> showParams = allParams
        .where((e) => schedule.otherParametrs.map((i) => i.id).contains(e.id))
        .toList();
    return GestureDetector(
      onTap: onTap,
      child: Card(
        margin: EdgeInsets.zero,
        color: NannyTheme.secondary,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Container(
          clipBehavior: Clip.hardEdge,
          padding: const EdgeInsets.only(top: 16, bottom: 32),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: NannyTheme.secondary,
            boxShadow: [
              BoxShadow(
                offset: const Offset(0, -2),
                blurRadius: 32,
                color: const Color(0xFF605B99).withOpacity(.19),
              ),
            ],
          ),
          child: Stack(
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 16, top: 12),
                    child: ClientProfileData(
                        photoPath: schedule.user.photoPath,
                        name: schedule.user.name,
                        childrenCount: schedule.childrenCount),
                  ),
                  SizedBox(
                    height: 81,
                    width: double.infinity,
                    child: ListView.separated(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 10),
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          final road = schedule.roads[index];
                          return Container(
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  blurRadius: 11,
                                  offset: const Offset(0, 4),
                                  color:
                                      const Color(0xFF021C3B).withOpacity(.12),
                                )
                              ],
                              color: Colors.white,
                              borderRadius: const BorderRadius.all(
                                Radius.circular(10),
                              ),
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 24, vertical: 8),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  road.weekDay.fullName,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                    color: Color(0xFF2B2B2B),
                                  ),
                                ),
                                const SizedBox(height: 1),
                                Text(
                                  "${road.startTime.formatTime()} - ${road.endTime.formatTime()}",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 16,
                                    color: Color(0xFF2B2B2B),
                                  ),
                                )
                              ],
                            ),
                          );
                        },
                        separatorBuilder: (context, index) =>
                            const SizedBox(width: 16),
                        itemCount: schedule.roads.length),
                  ),
                  const SizedBox(height: 7),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: List.generate(
                      showParams.length,
                      (index) => OtherParamWidget(
                          isSelected: true,
                          param: showParams[index].title ?? ''),
                    ),
                  ),
                  const SizedBox(height: 28),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Стоимость одного маршрута: ",
                              style: NannyTextStyles.defaultTextStyle.copyWith(
                                  fontSize: 12, fontWeight: FontWeight.w400),
                            ),
                            Text(
                              NannyUtils.formatCurrency(
                                  schedule.salaryRoad ?? 0),
                              style: NannyTextStyles.defaultTextStyle.copyWith(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                  fontFamily: ''),
                            )
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Общая стоимость: ",
                              style: NannyTextStyles.defaultTextStyle.copyWith(
                                  fontSize: 18, fontWeight: FontWeight.w400),
                            ),
                            Text(
                              NannyUtils.formatCurrency(schedule.allSalary),
                              style: NannyTextStyles.defaultTextStyle.copyWith(
                                  fontSize: 25,
                                  fontWeight: FontWeight.w700,
                                  fontFamily: ''),
                            )
                          ],
                        ),
                        if (onEditSchedule != null || onCancelSchedule != null)
                          const SizedBox(height: 32),
                        if (onEditSchedule != null)
                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  style: NannyButtonStyles.main,
                                  onPressed: onEditSchedule,
                                  child: const Text('Редактировать'),
                                ),
                              ),
                            ],
                          ),
                        if (onEditSchedule != null && onCancelSchedule != null)
                          const SizedBox(height: 12),
                        if (onCancelSchedule != null)
                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  style: NannyButtonStyles.secondary.copyWith(
                                    elevation: const WidgetStatePropertyAll(0),
                                  ),
                                  onPressed: onCancelSchedule,
                                  child: const Text('Отказаться'),
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                ],
              ),
              Positioned(
                right: 16,
                top: 16,
                child: DurationChip(duration: schedule.duration),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
