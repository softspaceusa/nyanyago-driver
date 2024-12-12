import 'package:nanny_core/models/from_api/roles/referal_data.dart';
import 'package:nanny_core/nanny_core.dart';

class UserInfo<T> {
  UserInfo({
    required this.surname,
    required this.name,
    required this.phone,
    required this.role,
    this.requestForPayment,
    required this.photoPath,
    required this.videoPath,
    this.chatToken = "",
    this.dateReg = "",
    this.jsonData = const {},
    this.roleData,
    this.id = 0,
    this.status = UserStatus.unrecognized,
    this.isActive = false,
    this.hasAuth = false,
  });

  final int id;
  final String chatToken;

  final String surname;
  final String name;
  final String phone;
  final List<UserType> role;
  final double? requestForPayment;
  final String photoPath;
  final String videoPath;
  final String dateReg;

  final UserStatus status;
  final bool isActive;
  final bool hasAuth;

  T? roleData;

  final Map<String, dynamic> jsonData;

  factory UserInfo.fromJson(Map<String, dynamic> json) {
    List<UserType> userTypes = [];
    List<String> roles = [];
    if (json['role'] != null) {
      for (String role in json['role']) {
        roles.add(role);
      }
    }

    userTypes = UserType.values.where((e) => roles.contains(e.name)).toList();

    String photo = json["photo_path"] ?? "";
    photo = photo.replaceAll(
        "https://77.232.137.74:5000/api/v1.0", NannyConsts.baseUrl);

    return UserInfo(
      id: json["id"] ?? json["id_user_referal"] ?? 0,
      chatToken: json["token"] ?? "",
      surname: json["surname"] ?? "",
      name: json["name"] ?? "",
      phone: (json["phone"] as String?)?.replaceAll("+", "") ?? "",
      role: userTypes,
      requestForPayment: (json["request_for_payment"] is int)
          ? (json["request_for_payment"] as int).toDouble()
          : json["request_for_payment"] as double?,
      photoPath: photo,
      videoPath: json["video_path"] ?? "",
      dateReg: json["date_reg"] ?? json["datetime_create"] ?? "",
      status: UserStatus.values.firstWhere((e) => e.name == json["status"],
          orElse: () => UserStatus.unrecognized),
      isActive: json['isActive'] ?? false,
      hasAuth: json["hasAuth"] ?? false,
      jsonData: json,
    );
  }

  factory UserInfo.createDriverRegForm() => UserInfo(
        surname: "",
        name: "",
        phone: "",
        role: [UserType.driver],
        requestForPayment: 0.0,
        photoPath: "",
        videoPath: "",
      );

  Map<String, dynamic> toJson() => {
        "surname": surname,
        "name": name,
        "phone": phone,
        "request_for_payment": requestForPayment,
        "photo_path": photoPath,
        "video_path": videoPath,
        "date_reg": dateReg,
      };

  UserInfo<E> copyWith<E>(
      {int? id,
      String? surname,
      String? name,
      String? phone,
      List<UserType>? role,
      double? requestForPayment,
      String? photoPath,
      String? videoPath,
      String? dateReg,
      UserStatus? status,
      bool? isActive,
      E? roleData,
      Map<String, dynamic>? getMeJson}) {
    return UserInfo<E>(
      id: id ?? this.id,
      chatToken: this.chatToken,
      surname: surname ?? this.surname,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      role: role ?? this.role,
      requestForPayment: requestForPayment ?? this.requestForPayment,
      photoPath: photoPath ?? this.photoPath,
      videoPath: videoPath ?? this.videoPath,
      dateReg: dateReg ?? this.dateReg,
      status: status ?? this.status,
      isActive: isActive ?? this.isActive,
      roleData: roleData ?? this.roleData as E,
      jsonData: getMeJson ?? this.jsonData,
    );
  }

  UserInfo<Driver> asDriver() {
    return copyWith<Driver>(
      roleData: Driver.fromJson(jsonData),
    );
  }

  UserInfo<Partner> asPartner() {
    return copyWith<Partner>(roleData: Partner.fromJson(jsonData));
  }

  UserInfo<Referral> asReferal() {
    return copyWith<Referral>(roleData: Referral.fromJson(jsonData));
  }
}
