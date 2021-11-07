import 'dart:convert';

import 'package:collector_app/providers/networks/models/response/base_response_model.dart';

DealerPromotionResposeModel dealerPromotionResposeModelFromJson(String str) =>
    DealerPromotionResposeModel.fromJson(json.decode(str));

class DealerPromotionResposeModel extends BaseResponseModel {
  DealerPromotionResposeModel({
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
  final int? total;
  final List<ResDatum>? resData;

  factory DealerPromotionResposeModel.fromJson(Map<String, dynamic> json) =>
      DealerPromotionResposeModel(
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
    required this.code,
    required this.promotionName,
    required this.appliedScrapCategory,
    required this.appliedAmount,
    required this.bonusAmount,
    required this.appliedFromTime,
    required this.appliedToTime,
  });

  final String id;
  final String code;
  final String promotionName;
  final String appliedScrapCategory;
  final int appliedAmount;
  final int bonusAmount;
  final String appliedFromTime;
  final String appliedToTime;

  factory ResDatum.fromJson(Map<String, dynamic> json) => ResDatum(
        id: json["id"],
        code: json["code"],
        promotionName: json["promotionName"],
        appliedScrapCategory: json["appliedScrapCategory"],
        appliedAmount: json["appliedAmount"],
        bonusAmount: json["bonusAmount"],
        appliedFromTime: json["appliedFromTime"],
        appliedToTime: json["appliedToTime"],
      );
}
