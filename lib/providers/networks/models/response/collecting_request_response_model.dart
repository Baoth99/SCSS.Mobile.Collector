import 'dart:convert';

import 'package:collector_app/providers/networks/models/response/base_response_model.dart';

CollectingRequestResponseModel collectingRequestResponseModelFromJson(
        String str) =>
    CollectingRequestResponseModel.fromJson(json.decode(str));

class CollectingRequestResponseModel extends BaseResponseModel {
  CollectingRequestResponseModel({
    required bool isSuccess,
    required int statusCode,
    this.msgCode,
    this.msgDetail,
    required this.total,
    required this.resData,
  }) : super(
          isSuccess: isSuccess,
          statusCode: statusCode,
        );

  dynamic msgCode;
  dynamic msgDetail;
  int total;
  List<ResDatum> resData;

  factory CollectingRequestResponseModel.fromJson(Map<String, dynamic> json) =>
      CollectingRequestResponseModel(
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
    required this.collectingRequestCode,
    required this.sellerName,
    required this.dayOfWeek,
    required this.collectingRequestDate,
    required this.fromTime,
    required this.toTime,
    required this.area,
    required this.durationTimeText,
    required this.durationTimeVal,
    required this.latitude,
    required this.longtitude,
    required this.isBulky,
    required this.requestType,
    required this.distance,
    required this.distanceText,
  });

  String id;
  String collectingRequestCode;
  String sellerName;
  int dayOfWeek;
  String collectingRequestDate;
  String fromTime;
  String toTime;
  String area;
  String durationTimeText;
  int durationTimeVal;
  double latitude;
  double longtitude;
  bool isBulky;
  int requestType;
  int distance;
  String distanceText;

  factory ResDatum.fromJson(Map<String, dynamic> json) => ResDatum(
        id: json["id"],
        collectingRequestCode: json["collectingRequestCode"],
        sellerName: json["sellerName"],
        dayOfWeek: json["dayOfWeek"],
        collectingRequestDate: json["collectingRequestDate"],
        fromTime: json["fromTime"],
        toTime: json["toTime"],
        area: json["area"],
        durationTimeText: json["durationTimeText"],
        durationTimeVal: json["durationTimeVal"],
        latitude: json["latitude"].toDouble(),
        longtitude: json["longtitude"].toDouble(),
        isBulky: json["isBulky"],
        requestType: json["requestType"],
        distance: json["distance"],
        distanceText: json["distanceText"],
      );
}
