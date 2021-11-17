// To parse this JSON data, do
//
//     final getSellCollectTransactionInfoReviewResponseModel = getSellCollectTransactionInfoReviewResponseModelFromJson(jsonString);

import 'dart:convert';

GetSellCollectTransactionInfoReviewResponseModel
    getSellCollectTransactionInfoReviewResponseModelFromJson(String str) =>
        GetSellCollectTransactionInfoReviewResponseModel.fromJson(
            json.decode(str));

class GetSellCollectTransactionInfoReviewResponseModel {
  GetSellCollectTransactionInfoReviewResponseModel({
    required this.isSuccess,
    required this.statusCode,
    required this.msgCode,
    required this.msgDetail,
    required this.total,
    required this.resData,
  });

  bool isSuccess;
  int statusCode;
  dynamic msgCode;
  dynamic msgDetail;
  dynamic total;
  GetSellCollectTransactionInfoReviewModel resData;

  factory GetSellCollectTransactionInfoReviewResponseModel.fromJson(
          Map<String, dynamic> json) =>
      GetSellCollectTransactionInfoReviewResponseModel(
        isSuccess: json["isSuccess"] == null ? null : json["isSuccess"],
        statusCode: json["statusCode"] == null ? null : json["statusCode"],
        msgCode: json["msgCode"],
        msgDetail: json["msgDetail"],
        total: json["total"],
        resData:
            GetSellCollectTransactionInfoReviewModel.fromJson(json["resData"]),
      );
}

class GetSellCollectTransactionInfoReviewModel {
  GetSellCollectTransactionInfoReviewModel({
    required this.collectingRequestId,
    required this.collectingRequestCode,
    required this.sellerName,
    required this.transactionFeePercent,
    required this.sellerPhone,
  });

  String collectingRequestId;
  String collectingRequestCode;
  String sellerName;
  double transactionFeePercent;
  String sellerPhone;

  factory GetSellCollectTransactionInfoReviewModel.fromJson(
          Map<String, dynamic> json) =>
      GetSellCollectTransactionInfoReviewModel(
        collectingRequestId: json["collectingRequestId"] == null
            ? null
            : json["collectingRequestId"],
        collectingRequestCode: json["collectingRequestCode"] == null
            ? null
            : json["collectingRequestCode"],
        sellerName: json["sellerName"] == null ? null : json["sellerName"],
        transactionFeePercent: json["transactionFeePercent"] == null
            ? null
            : json["transactionFeePercent"].toDouble(),
        sellerPhone: json["sellerPhone"] == null ? null : json["sellerPhone"],
      );
}
