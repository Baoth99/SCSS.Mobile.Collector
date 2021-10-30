import 'dart:convert';

import 'package:collector_app/providers/networks/models/response/base_response_model.dart';

DealerTransactionResponseModel dealerTransactionResponseModelFromJson(
        String str) =>
    DealerTransactionResponseModel.fromJson(json.decode(str));

class DealerTransactionResponseModel extends BaseResponseModel {
  DealerTransactionResponseModel({
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

  factory DealerTransactionResponseModel.fromJson(Map<String, dynamic> json) =>
      DealerTransactionResponseModel(
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
    required this.transactionId,
    required this.transactionCode,
    required this.dealerName,
    required this.dealerImageUrl,
    required this.transactionDate,
    required this.transactionTime,
    required this.dayOfWeek,
    required this.total,
  });

  String transactionId;
  String transactionCode;
  String dealerName;
  String? dealerImageUrl;
  String transactionDate;
  String transactionTime;
  int dayOfWeek;
  int total;

  factory ResDatum.fromJson(Map<String, dynamic> json) => ResDatum(
        transactionId: json["transactionId"],
        transactionCode: json["transactionCode"],
        dealerName: json["dealerName"],
        dealerImageUrl: json["dealerImageURL"],
        transactionDate: json["transactionDate"],
        transactionTime: json["transactionTime"],
        dayOfWeek: json["dayOfWeek"],
        total: json["total"],
      );
}
