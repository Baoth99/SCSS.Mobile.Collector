import 'dart:convert';

import 'package:collector_app/providers/networks/models/response/base_response_model.dart';

ReceiveGetResponseModel receiveGetResponseModelFromJson(String str) =>
    ReceiveGetResponseModel.fromJson(json.decode(str));

class ReceiveGetResponseModel extends BaseResponseModel {
  ReceiveGetResponseModel({
    required bool isSuccess,
    required int statusCode,
    this.msgCode,
    this.msgDetail,
    required this.total,
    this.resData,
  }) : super(
          isSuccess: isSuccess,
          statusCode: statusCode,
        );

  dynamic msgCode;
  dynamic msgDetail;
  int total;
  List<ResDatum>? resData;

  factory ReceiveGetResponseModel.fromJson(Map<String, dynamic> json) =>
      ReceiveGetResponseModel(
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
    required this.collectingAddressName,
    required this.collectingAddress,
    required this.isBulky,
    required this.requestType,
    required this.distance,
    required this.distanceText,
    required this.durationTimeText,
    required this.durationTimeVal,
  });

  String id;
  String collectingRequestCode;
  String sellerName;
  int dayOfWeek;
  String collectingRequestDate;
  String fromTime;
  String toTime;
  String collectingAddressName;
  String collectingAddress;
  bool isBulky;
  int requestType;
  int distance;
  String distanceText;
  String durationTimeText;
  int durationTimeVal;

  factory ResDatum.fromJson(Map<String, dynamic> json) => ResDatum(
        id: json["id"],
        collectingRequestCode: json["collectingRequestCode"],
        sellerName: json["sellerName"],
        dayOfWeek: json["dayOfWeek"],
        collectingRequestDate: json["collectingRequestDate"],
        fromTime: json["fromTime"],
        toTime: json["toTime"],
        collectingAddressName: json["collectingAddressName"],
        collectingAddress: json["collectingAddress"],
        isBulky: json["isBulky"],
        requestType: json["requestType"],
        distance: json["distance"],
        distanceText: json["distanceText"],
        durationTimeText: json["durationTimeText"],
        durationTimeVal: json["durationTimeVal"],
      );
}
