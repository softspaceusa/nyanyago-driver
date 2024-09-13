import 'package:nanny_core/api/api_models/answer_schedule_request.dart';
import 'package:nanny_core/api/api_models/onetime_drive_request.dart';
import 'package:nanny_core/api/request_builder.dart';
import 'package:nanny_core/models/from_api/drive_and_map/drive_tariff.dart';
import 'package:nanny_core/models/from_api/drive_and_map/one_time_drive_socket.dart';
import 'package:nanny_core/models/from_api/drive_and_map/schedule.dart';
import 'package:nanny_core/models/from_api/drive_and_map/schedule_responses_data.dart';
import 'package:nanny_core/nanny_core.dart';

class NannyOrdersApi {
  static Future<ApiResponse<void>> createSchedule(Schedule schedule) {
    return RequestBuilder<void>().create(
        dioRequest:
            DioRequest.dio.post("/orders/schedule", data: schedule.toJson()),
        errorCodeMsgs: {405: "Тариф не найден!"});
  }

  static Future<ApiResponse<Schedule>> getScheduleById(int id) {
    return RequestBuilder<Schedule>().create(
        dioRequest: DioRequest.dio.get("/orders/schedule/$id"),
        onSuccess: (response) => Schedule.fromJson(response.data["schedule"]),
        errorCodeMsgs: {404: "Расписание не найдено!"});
  }

  static Future<ApiResponse<Schedule>> deleteScheduleById(int id) {
    return RequestBuilder<Schedule>().create(
        dioRequest: DioRequest.dio.delete("/orders/schedule/$id"),
        errorCodeMsgs: {404: "Расписание не найдено!"});
  }

  static Future<ApiResponse<List<Schedule>>> getSchedules() {
    return RequestBuilder<List<Schedule>>().create(
      dioRequest: DioRequest.dio.get("/orders/schedules"),
      onSuccess: (response) => List<Schedule>.from(
          response.data["schedules"].map((x) => Schedule.fromJson(x))),
    );
  }

  static Future<ApiResponse<Schedule>> deleteScheduleRoadById(int id) {
    return RequestBuilder<Schedule>().create(
        dioRequest: DioRequest.dio.delete("/orders/schedule_road/$id"),
        errorCodeMsgs: {404: "Расписание не найдено!"});
  }

  static Future<ApiResponse<Road>> createScheduleRoadById(int id, Road road) {
    return RequestBuilder<Road>().create(
        dioRequest: DioRequest.dio
            .post("/orders/schedule_road/$id", data: road.toJson()),
        errorCodeMsgs: {404: "Расписание не найдено!"});
  }

  static Future<ApiResponse<Road>> getScheduleRoadById(int id) {
    return RequestBuilder<Road>().create(
        dioRequest: DioRequest.dio.get("/orders/schedule_road/$id"),
        onSuccess: (response) => Road.fromJson(response.data["schedule_road"]),
        errorCodeMsgs: {404: "Расписание не найдено!"});
  }

  static Future<ApiResponse<Road>> updateScheduleRoadById(Road road) {
    return RequestBuilder<Road>().create(
        dioRequest:
            DioRequest.dio.put("/orders/schedule_road", data: road.toJson()),
        errorCodeMsgs: {404: "Расписание не найдено!"});
  }

  static Future<ApiResponse<List<ScheduleResponsesData>>>
      getScheduleResponses() async {
    return RequestBuilder<List<ScheduleResponsesData>>().create(
      dioRequest: DioRequest.dio.get("/orders/get_schedule_responses"),
      onSuccess: (response) => List<ScheduleResponsesData>.from(response
          .data["responses"]
          .map((x) => ScheduleResponsesData.fromJson(x))),
    );
  }

  static Future<ApiResponse<void>> answerScheduleRequest(
      AnswerScheduleRequest request) async {
    return RequestBuilder<void>().create(
        dioRequest: DioRequest.dio
            .post("/orders/answer_schedule_responses", data: request.toJson()));
  }

  static Future<ApiResponse<void>> getCurrentOrder() =>
      throw UnimplementedError(); // TODO: Доделать
  static Future<ApiResponse<void>> startCurrentDrive() =>
      throw UnimplementedError(); // TODO: Доделать

  static Future<ApiResponse<DriverUserTextData>> getDriver(int id) async {
    var data = <String, dynamic>{"id": id};

    return RequestBuilder<DriverUserTextData>().create(
      dioRequest: DioRequest.dio.post('/orders/get_driver', data: data),
      onSuccess: (response) =>
          DriverUserTextData.fromJson(response.data["driver"]),
    );
  }

  static Future<ApiResponse> declineOrder(int orderId) =>
      RequestBuilder().create(
          dioRequest: DioRequest.dio
              .post('/orders/decline_order', data: {"id_order": orderId}));

  static Future<ApiResponse> acceptOrder(int orderId) =>
      RequestBuilder().create(
          dioRequest: DioRequest.dio
              .post('/orders/accept_order', data: {"id_order": orderId}));

  static Future<ApiResponse<List<OneTimeDriveResponse>>> getOnetimeOrder(
      {bool isOneTime = true}) async {
    return RequestBuilder<List<OneTimeDriveResponse>>().create(
        dioRequest: DioRequest.dio
            .get('/orders/get_orders?type_order=${isOneTime ? 1 : 2}'),
        onSuccess: (response) {
          return ((response.data['orders'] as List<dynamic>))
              .where((e) => e != null)
              .map((e) {
            return OneTimeDriveResponse.fromJson(e);
          }).toList();
        });
  }

  static Future<ApiResponse<List<DriveTariff>>> getOnetimePrices(
      int duration, int distance) async {
    return RequestBuilder<List<DriveTariff>>().create(
      dioRequest: DioRequest.dio.get(
          "/orders/get_onetime_prices?duration=$duration&distance=$distance"),
      onSuccess: (response) => List<DriveTariff>.from(
          response.data["tariffs"].map((x) => DriveTariff.fromJson(x))),
    );
  }

  static Future<ApiResponse<String>> getPriceByRoad(
      {required DriveTariff tariff,
      required int duration,
      required int distance}) async {
    return RequestBuilder<String>().create(
        dioRequest: DioRequest.dio.get(
      "/orders/get_price_by_road?id_tariff=${tariff.id}&duration=$duration&distance=$distance",
    ));
  }

  static Future<ApiResponse<String>> startOnetimeOrder(
      OnetimeDriveRequest request) async {
    return RequestBuilder<String>().create(
      dioRequest: DioRequest.dio
          .post("/orders/start_onetime_drive", data: request.toJson()),
      onSuccess: (response) => response.data["token"],
    );
  }
}
