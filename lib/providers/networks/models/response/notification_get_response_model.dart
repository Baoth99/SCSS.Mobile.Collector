import 'dart:convert';

import 'package:collector_app/providers/networks/models/response/base_response_model.dart';

NotificationGetResponseModel notificationGetResponseModelFromJson(String str) =>
    NotificationGetResponseModel.fromJson(json.decode(str));

class NotificationGetResponseModel extends BaseResponseModel {
  NotificationGetResponseModel({
    required bool isSuccess,
    required int statusCode,
    this.msgCode,
    this.msgDetail,
    this.total,
    this.resData,
  }) : super(
          isSuccess: isSuccess,
          statusCode: statusCode,
        );

  dynamic msgCode;
  dynamic msgDetail;
  int? total;
  List<ResDatum>? resData;

  factory NotificationGetResponseModel.fromJson(Map<String, dynamic> json) =>
      NotificationGetResponseModel(
        isSuccess: json["isSuccess"],
        statusCode: json["statusCode"],
        msgCode: json["msgCode"],
        msgDetail: json["msgDetail"],
        total: json["total"],
        resData: List<ResDatum>.from(
            json["resData"].map((x) => ResDatum.fromJson(x))),
      );
}

class ResDatum {
  ResDatum({
    required this.id,
    required this.title,
    required this.body,
    required this.date,
    required this.dataCustom,
    required this.isRead,
    required this.notiType,
    required this.previousTime,
  });

  String id;
  String title;
  String body;
  String date;
  String dataCustom;
  bool isRead;
  int notiType;
  String previousTime;

  factory ResDatum.fromJson(Map<String, dynamic> json) => ResDatum(
        id: json["id"],
        title: json["title"],
        body: json["body"],
        date: json["date"],
        dataCustom: json["dataCustom"],
        isRead: json["isRead"],
        notiType: json["notiType"],
        previousTime: json["previousTime"],
      );
}
