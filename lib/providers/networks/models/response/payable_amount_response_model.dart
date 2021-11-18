import 'dart:convert';

import 'package:collector_app/providers/networks/models/response/base_response_model.dart';

PayableAmountResponseModel payableAmountResponseModelFromJson(String str) =>
    PayableAmountResponseModel.fromJson(json.decode(str));

class PayableAmountResponseModel extends BaseResponseModel {
  PayableAmountResponseModel({
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

  final dynamic msgCode;
  final dynamic msgDetail;
  final int total;
  final List<ResDatum> resData;

  factory PayableAmountResponseModel.fromJson(Map<String, dynamic> json) =>
      PayableAmountResponseModel(
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
    required this.timePeriod,
    required this.dateTimeFrom,
    required this.dateTimeTo,
    required this.isFinished,
    required this.amount,
  });

  final String id;
  final String timePeriod;
  final DateTime dateTimeFrom;
  final DateTime dateTimeTo;
  final bool isFinished;
  final int amount;

  factory ResDatum.fromJson(Map<String, dynamic> json) => ResDatum(
        id: json["id"],
        timePeriod: json["timePeriod"],
        dateTimeFrom: DateTime.parse(json["dateTimeFrom"]),
        dateTimeTo: DateTime.parse(json["dateTimeTo"]),
        isFinished: json["isFinished"],
        amount: json["amount"],
      );
}
