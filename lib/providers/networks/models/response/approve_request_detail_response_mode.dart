import 'dart:convert';

import 'package:collector_app/providers/networks/models/response/base_response_model.dart';

ApproveRequestDetailResponseModel approveRequestDetailResponseModelFromJson(
        String str) =>
    ApproveRequestDetailResponseModel.fromJson(json.decode(str));

class ApproveRequestDetailResponseModel extends BaseResponseModel {
  ApproveRequestDetailResponseModel({
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

  factory ApproveRequestDetailResponseModel.fromJson(
          Map<String, dynamic> json) =>
      ApproveRequestDetailResponseModel(
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
    required this.collectingRequestDate,
    required this.dayOfWeek,
    required this.fromTime,
    required this.toTime,
    required this.isBulky,
    required this.note,
    this.scrapImgUrl,
    required this.collectingAddressName,
    required this.collectingAddress,
    required this.latitude,
    required this.longtitude,
    this.sellerImgUrl,
    required this.sellerName,
    required this.sellerPhone,
    required this.sellerGender,
  });

  String id;
  String collectingRequestCode;
  String collectingRequestDate;
  int dayOfWeek;
  String fromTime;
  String toTime;
  bool isBulky;
  String note;
  String? scrapImgUrl;
  String collectingAddressName;
  String collectingAddress;
  double latitude;
  double longtitude;
  String? sellerImgUrl;
  String sellerName;
  String sellerPhone;
  int sellerGender;

  factory ResData.fromJson(Map<String, dynamic> json) => ResData(
        id: json["id"],
        collectingRequestCode: json["collectingRequestCode"],
        collectingRequestDate: json["collectingRequestDate"],
        dayOfWeek: json["dayOfWeek"],
        fromTime: json["fromTime"],
        toTime: json["toTime"],
        isBulky: json["isBulky"],
        note: json["note"],
        scrapImgUrl: json["scrapImgUrl"],
        collectingAddressName: json["collectingAddressName"],
        collectingAddress: json["collectingAddress"],
        latitude: json["latitude"].toDouble(),
        longtitude: json["longtitude"].toDouble(),
        sellerImgUrl: json["sellerImgUrl"],
        sellerName: json["sellerName"],
        sellerPhone: json["sellerPhone"],
        sellerGender: json["sellerGender"],
      );
}
