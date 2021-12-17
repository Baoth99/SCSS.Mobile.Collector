// To parse this JSON data, do
//
//     final collectorPhoneResponseModel = collectorPhoneResponseModelFromJson(jsonString);

import 'dart:convert';

import 'package:collector_app/blocs/models/collector_phone_model.dart';

CollectorPhoneResponseModel collectorPhoneResponseModelFromJson(String str) =>
    CollectorPhoneResponseModel.fromJson(json.decode(str));

String collectorPhoneResponseModelToJson(CollectorPhoneResponseModel data) =>
    json.encode(data.toJson());

class CollectorPhoneResponseModel {
  CollectorPhoneResponseModel({
    required this.isSuccess,
    required this.statusCode,
    required this.msgCode,
    required this.msgDetail,
    required this.total,
    required this.collectorPhoneModels,
  });

  bool isSuccess;
  int statusCode;
  dynamic msgCode;
  dynamic msgDetail;
  int total;
  List<CollectorPhoneModel>? collectorPhoneModels;

  factory CollectorPhoneResponseModel.fromJson(Map<String, dynamic> json) =>
      CollectorPhoneResponseModel(
        isSuccess: json["isSuccess"] == null ? null : json["isSuccess"],
        statusCode: json["statusCode"] == null ? null : json["statusCode"],
        msgCode: json["msgCode"],
        msgDetail: json["msgDetail"],
        total: json["total"] == null ? null : json["total"],
        collectorPhoneModels: json["resData"] == null
            ? null
            : List<CollectorPhoneModel>.from(
                json["resData"].map((x) => CollectorPhoneModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "isSuccess": isSuccess,
        "statusCode": statusCode,
        "msgCode": msgCode,
        "msgDetail": msgDetail,
        "total": total,
        "resData": collectorPhoneModels == null
            ? null
            : List<dynamic>.from(collectorPhoneModels!.map((x) => x.toJson())),
      };
}
