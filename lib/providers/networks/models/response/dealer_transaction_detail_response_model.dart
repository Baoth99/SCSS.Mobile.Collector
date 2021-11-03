import 'dart:convert';

import 'package:collector_app/providers/networks/models/response/base_response_model.dart';

DealerTransactionDetailResponseModel
    dealerTransactionDetailResponseModelFromJson(String str) =>
        DealerTransactionDetailResponseModel.fromJson(json.decode(str));

class DealerTransactionDetailResponseModel extends BaseResponseModel {
  DealerTransactionDetailResponseModel({
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

  final dynamic msgCode;
  final dynamic msgDetail;
  final dynamic total;
  final ResData? resData;

  factory DealerTransactionDetailResponseModel.fromJson(
          Map<String, dynamic> json) =>
      DealerTransactionDetailResponseModel(
        isSuccess: json["isSuccess"],
        statusCode: json["statusCode"],
        msgCode: json["msgCode"],
        msgDetail: json["msgDetail"],
        total: json["total"],
        resData:
            json["resData"] == null ? null : ResData.fromJson(json["resData"]),
      );
}

class ResData {
  ResData({
    required this.transId,
    required this.transactionCode,
    required this.trasactionDateTime,
    required this.dealerInfo,
    required this.feedback,
    required this.itemDetails,
    required this.total,
    required this.totalBonus,
    required this.awardPoint,
  });

  final String transId;
  final String transactionCode;
  final DateTime trasactionDateTime;
  final DealerInfo dealerInfo;
  final Feedback feedback;
  final List<ItemDetail> itemDetails;
  final int total;
  final int totalBonus;
  final int awardPoint;

  factory ResData.fromJson(Map<String, dynamic> json) => ResData(
        transId: json["transId"],
        transactionCode: json["transactionCode"],
        trasactionDateTime: DateTime.parse(json["trasactionDateTime"]),
        dealerInfo: DealerInfo.fromJson(json["dealerInfo"]),
        feedback: Feedback.fromJson(json["feedback"]),
        itemDetails: List<ItemDetail>.from(
            json["itemDetails"].map((x) => ItemDetail.fromJson(x))),
        total: json["total"],
        totalBonus: json["totalBonus"],
        awardPoint: json["awardPoint"],
      );
}

class DealerInfo {
  DealerInfo({
    required this.dealerName,
    required this.dealerPhone,
    this.dealerImageUrl,
  });

  final String dealerName;
  final String dealerPhone;
  final String? dealerImageUrl;

  factory DealerInfo.fromJson(Map<String, dynamic> json) => DealerInfo(
        dealerName: json["dealerName"],
        dealerPhone: json["dealerPhone"],
        dealerImageUrl: json["dealerImageUrl"],
      );
}

class Feedback {
  Feedback({
    required this.feedbackStatus,
    this.ratingFeedback,
  });

  final int feedbackStatus;
  final double? ratingFeedback;

  factory Feedback.fromJson(Map<String, dynamic> json) => Feedback(
        feedbackStatus: json["feedbackStatus"],
        ratingFeedback: json["ratingFeedback"]?.toDouble(),
      );
}

class ItemDetail {
  ItemDetail({
    this.scrapCategoryName,
    this.unit,
    required this.quantity,
    required this.total,
    required this.isBonus,
    required this.bonusAmount,
    this.promotionCode,
    this.promoAppliedBonus,
  });

  final String? scrapCategoryName;
  final String? unit;
  final double quantity;
  final int total;
  final bool isBonus;
  final int bonusAmount;
  final String? promotionCode;
  final int? promoAppliedBonus;

  factory ItemDetail.fromJson(Map<String, dynamic> json) => ItemDetail(
        scrapCategoryName: json["scrapCategoryName"],
        unit: json["unit"],
        quantity: json["quantity"].toDouble(),
        total: json["total"],
        isBonus: json["isBonus"],
        bonusAmount: json["bonusAmount"],
        promotionCode: json["promotionCode"],
        promoAppliedBonus: json["promoAppliedBonus"],
      );
}
