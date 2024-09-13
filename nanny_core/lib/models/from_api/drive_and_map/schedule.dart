import 'package:flutter/material.dart';
import 'package:nanny_core/constants.dart';
import 'package:nanny_core/models/from_api/drive_and_map/address_data.dart';
import 'package:nanny_core/models/from_api/drive_and_map/drive_tariff.dart';
import 'package:nanny_core/models/from_api/other_parametr.dart';

class Schedule {
    Schedule({
      required this.title,
      required this.duration,
      required this.childrenCount,
      required this.weekdays,
      required this.tariff,
      required this.otherParametrs,
      required this.roads,
      this.description = "",
      this.id,
      this.salary,
    });

    final int? id;
    final String title;
    final String description;
    final int duration;
    final int childrenCount;
    final List<NannyWeekday> weekdays;
    final DriveTariff tariff;
    final List<OtherParametr> otherParametrs;
    final List<Road> roads;
    final double? salary;

    factory Schedule.fromJson(Map<String, dynamic> json){
        return Schedule(
          id: json["id"],
          title: json["title"] ?? "",
          description: json["description"] ?? "",
          duration: json["duration"] ?? 0,
          childrenCount: json["children_count"] ?? 0,
          weekdays: json["week_days"] == null ? [] : List<NannyWeekday>.from(json["week_days"].map((x) => NannyWeekday.values[x])),
          tariff: DriveTariff(id: json["id_tariff"]),
          otherParametrs: json["other_parametrs"] == null ? [] : List<OtherParametr>.from(json["other_parametrs"]!.map((x) => OtherParametr.fromJson(x))),
          roads: json["roads"] == null ? [] : List<Road>.from(json["roads"]!.map((x) => Road.fromJson(x))),
          salary: json["salary"]
        );
    }

    Map<String, dynamic> toJson() => {
      "title": title,
      "description": description,
      "duration": duration,
      "children_count": childrenCount,
      "week_days": weekdays.map((x) => x.index).toList(),
      "id_tariff": tariff.id,
      "other_parametrs": otherParametrs.map((x) => x.toGraphJson(childrenCount)).toList(),
      "roads": roads.map((x) => x.toJson()).toList(),
    };
}

class Road {
    Road({
        required this.weekDay,
        required this.startTime,
        required this.endTime,
        required this.addresses,
        required this.title,
        required this.typeDrive,
        this.id
    });

    final int? id;
    final NannyWeekday weekDay;
    final TimeOfDay startTime;
    final TimeOfDay endTime;
    final List<DriveAddress> addresses;
    final String title;
    final List<DriveType> typeDrive;

    factory Road.fromJson(Map<String, dynamic> json){ 
        return Road(
          id: json["id"],
          weekDay: NannyWeekday.values[json["week_day"]],
          startTime: parseTime(json['start_time']),
          endTime: parseTime(json['end_time']),
          addresses: json["addresses"] == null ? [] : List<DriveAddress>.from(json["addresses"]!.map((x) => DriveAddress.fromJson(x))),
          title: json["title"] ?? "",
          typeDrive: json["type_drive"] == null ? [] : List<DriveType>.from(json["type_drive"].map((x) => DriveType.values[x])),
        );
    }

    Map<String, dynamic> toJson() => {
        "week_day": weekDay.index,
        "start_time": startTime.formatTime(),
        "end_time": endTime.formatTime(),
        "addresses": addresses.map((x) => x.toJson()).toList(),
        "title": title,
        "type_drive": typeDrive.map((x) => x.index).toList(),
    };

    static TimeOfDay parseTime(String time) {
      List<String> parts = time.split(':');
      int hours = int.parse(parts.first);
      int minutes = int.parse(parts.last);

      return TimeOfDay(hour: hours, minute: minutes);
    }
}

extension TimeParse on TimeOfDay {
  String formatTime() => 
  "${hour < 10 ? "0$hour" : hour}"
  ":${minute < 10 ? "0$minute" : minute}";
}

/*
{
	"duration": 0,
	"children_count": 0,
	"week_days": [
		0
	],
	"id_tariff": 0,
	"other_parametrs": [
		{
			"parameter": 0,
			"count": 1
		}
	],
	"roads": [
		{
			"week_day": 0,
			"start_time": "string",
			"end_time": "string",
			"addresses": [
				{
					"from_address": {
						"address": "string",
						"location": {
							"latitude": 0,
							"longitude": 0
						}
					},
					"to_address": {
						"address": "string",
						"location": {
							"latitude": 0,
							"longitude": 0
						}
					}
				}
			],
			"title": "string",
			"type_drive": [
				0
			]
		}
	]
}*/
