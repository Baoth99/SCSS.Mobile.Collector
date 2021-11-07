// To parse this JSON data, do
//
//     final dealerDetailResponseModel = dealerDetailResponseModelFromJson(jsonString);

import 'dart:convert';

import 'package:collector_app/providers/networks/models/response/base_response_model.dart';

DealerDetailResponseModel dealerDetailResponseModelFromJson(String str) =>
    DealerDetailResponseModel.fromJson(json.decode(str));

class DealerDetailResponseModel extends BaseResponseModel{
  DealerDetailResponseModel({
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
  ResData? resData;

  factory DealerDetailResponseModel.fromJson(Map<String, dynamic> json) => DealerDetailResponseModel(
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
    required this.dealerId,
    required this.dealerName,
    this.dealerImageUrl,
    required this.dealerPhone,
    required this.rating,
    required this.openTime,
    required this.closeTime,
    required this.dealerAddress,
    this.latitude,
    this.longtitude,
  });

  String dealerId;
  String dealerName;
  String? dealerImageUrl;
  String dealerPhone;
  double rating;
  String openTime;
  String closeTime;
  String dealerAddress;
  double? latitude;
  double? longtitude;

  factory ResData.fromJson(Map<String, dynamic> json) => ResData(
    dealerId: json["dealerId"],
    dealerName: json["dealerName"],
    dealerImageUrl: json["dealerImageUrl"],
    dealerPhone: json["dealerPhone"],
    rating: json["rating"].toDouble(),
    openTime: json["openTime"],
    closeTime: json["closeTime"],
    dealerAddress: json["dealerAddress"],
    latitude: json["latitude"].toDouble(),
    longtitude: json["longtitude"].toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "dealerId": dealerId,
    "dealerName": dealerName,
    "dealerImageUrl": dealerImageUrl,
    "dealerPhone": dealerPhone,
    "rating": rating,
    "openTime": openTime,
    "closeTime": closeTime,
    "dealerAddress": dealerAddress,
    "latitude": latitude,
    "longtitude": longtitude,
  };
}
