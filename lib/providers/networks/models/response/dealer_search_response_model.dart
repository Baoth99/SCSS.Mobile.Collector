import 'dart:convert';

import 'package:collector_app/providers/networks/models/response/base_response_model.dart';

DelaerSearchResponseModel delaerSearchResponseModelFromJson(String str) =>
    DelaerSearchResponseModel.fromJson(json.decode(str));

class DelaerSearchResponseModel extends BaseResponseModel {
  DelaerSearchResponseModel({
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

  factory DelaerSearchResponseModel.fromJson(Map<String, dynamic> json) =>
      DelaerSearchResponseModel(
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
    this.dealerId,
    this.dealerName,
    this.isActive,
    this.dealerAddress,
    this.latitude,
    this.longtitude,
    this.dealerImageUrl,
    this.openTime,
    this.closeTime,
    this.distance,
    this.distanceText,
  });

  String? dealerId;
  String? dealerName;
  bool? isActive;
  String? dealerAddress;
  double? latitude;
  double? longtitude;
  String? dealerImageUrl;
  String? openTime;
  String? closeTime;
  int? distance;
  String? distanceText;

  factory ResDatum.fromJson(Map<String, dynamic> json) => ResDatum(
        dealerId: json["dealerId"],
        dealerName: json["dealerName"],
        isActive: json["isActive"],
        dealerAddress: json["dealerAddress"],
        latitude: json["latitude"].toDouble(),
        longtitude: json["longtitude"].toDouble(),
        dealerImageUrl: json["dealerImageUrl"],
        openTime: json["openTime"],
        closeTime: json["closeTime"],
        distance: json["distance"],
        distanceText: json["distanceText"],
      );
}
