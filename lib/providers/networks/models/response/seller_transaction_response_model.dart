// To parse this JSON data, do
//
//     final sellerTransactionResponseModel = sellerTransactionResponseModelFromJson(jsonString);

import 'dart:convert';

import 'package:collector_app/providers/networks/models/response/base_response_model.dart';

SellerTransactionResponseModel sellerTransactionResponseModelFromJson(
        String str) =>
    SellerTransactionResponseModel.fromJson(json.decode(str));

class SellerTransactionResponseModel extends BaseResponseModel {
  SellerTransactionResponseModel({
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

  factory SellerTransactionResponseModel.fromJson(Map<String, dynamic> json) =>
      SellerTransactionResponseModel(
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
    required this.collectingRequestId,
    required this.sellerName,
    required this.collectingRequestCode,
    required this.doneDateTime,
    required this.dayOfWeek,
    required this.date,
    required this.time,
    required this.total,
    required this.status,
  });

  String collectingRequestId;
  String sellerName;
  String collectingRequestCode;
  DateTime doneDateTime;
  int dayOfWeek;
  String date;
  String time;
  int? total;
  int status;

  factory ResDatum.fromJson(Map<String, dynamic> json) => ResDatum(
        collectingRequestId: json["collectingRequestId"],
        sellerName: json["sellerName"],
        collectingRequestCode: json["collectingRequestCode"],
        doneDateTime: DateTime.parse(json["doneDateTime"]),
        dayOfWeek: json["dayOfWeek"],
        date: json["date"],
        time: json["time"],
        total: json["total"] == null ? null : json["total"],
        status: json["status"],
      );
}
