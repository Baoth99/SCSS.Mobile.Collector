import 'dart:convert';

import 'package:collector_app/providers/networks/models/response/base_response_model.dart';

CollectingRequestDetailResponseModel
    collectingRequestDetailResponseModelFromJson(String str) =>
        CollectingRequestDetailResponseModel.fromJson(json.decode(str));

class CollectingRequestDetailResponseModel extends BaseResponseModel {
  CollectingRequestDetailResponseModel({
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
  dynamic total;
  ResData? resData;

  factory CollectingRequestDetailResponseModel.fromJson(
          Map<String, dynamic> json) =>
      CollectingRequestDetailResponseModel(
        isSuccess: json["isSuccess"],
        statusCode: json["statusCode"],
        msgCode: json["msgCode"],
        msgDetail: json["msgDetail"],
        total: json["total"],
        resData: ResData.fromJson(json["resData"]),
      );
}

class ResData {
  ResData({
    required this.id,
    required this.collectingRequestCode,
    required this.sellerName,
    required this.sellerGender,
    this.sellerProfileUrl,
    this.scrapImageUrl,
    required this.dayOfWeek,
    required this.collectingRequestDate,
    required this.fromTime,
    required this.toTime,
    required this.area,
    required this.latitude,
    required this.longtitude,
    required this.isBulky,
    required this.note,
    required this.requestType,
    required this.isAllowedToApprove,
  });

  String id;
  String collectingRequestCode;
  String sellerName;
  int sellerGender;
  String? sellerProfileUrl;
  String? scrapImageUrl;
  int dayOfWeek;
  String collectingRequestDate;
  String fromTime;
  String toTime;
  String area;
  double latitude;
  double longtitude;
  bool isBulky;
  String note;
  int requestType;
  bool isAllowedToApprove;

  factory ResData.fromJson(Map<String, dynamic> json) => ResData(
        id: json["id"],
        collectingRequestCode: json["collectingRequestCode"],
        sellerName: json["sellerName"],
        sellerGender: json["sellerGender"],
        sellerProfileUrl: json["sellerProfileUrl"],
        scrapImageUrl: json["scrapImageUrl"],
        dayOfWeek: json["dayOfWeek"],
        collectingRequestDate: json["collectingRequestDate"],
        fromTime: json["fromTime"],
        toTime: json["toTime"],
        area: json["area"],
        latitude: json["latitude"].toDouble(),
        longtitude: json["longtitude"].toDouble(),
        isBulky: json["isBulky"],
        note: json["note"],
        requestType: json["requestType"],
        isAllowedToApprove: json["isAllowedToApprove"],
      );
}
