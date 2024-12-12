import 'package:nanny_core/models/from_api/roles/referal_data.dart';
import 'package:nanny_core/models/from_api/user_info.dart';

class MyReferalData {
  MyReferalData({
    required this.allIncoming,
    required this.getPercent,
    required this.referrals,
  });

  final int allIncoming;
  final double getPercent;
  final List<UserInfo<Referral>> referrals;

  factory MyReferalData.fromJson(Map<String, dynamic> json) {
    return MyReferalData(
        allIncoming: json["all_incoming"] ?? 0,
        getPercent: double.tryParse(json["get_percent"].toString()) ?? 0.0,
        referrals: json["referals"] == null
            ? []
            : List<UserInfo<Referral>>.from(json["referals"]!
                .map((x) => UserInfo.fromJson(x).asReferal())));
  }

  Map<String, dynamic> toJson() => {
        "all_incoming": allIncoming,
        "get_percent": getPercent,
        "referals": referrals.map((x) => x.toJson()).toList(),
      };
}

/*
{
	"all_incoming": 0,
	"get_percent": 0,
	"referals": [
		{
			"id": 0,
			"name": "string",
			"surname": "string",
			"photo_path": "string",
			"date_reg": "string",
			"all_incoming": 0,
			"get_percent": 0
		}
	]
}*/
