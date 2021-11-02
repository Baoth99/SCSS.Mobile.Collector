import 'dart:convert';

import 'package:collector_app/providers/networks/models/response/base_response_model.dart';

GetStatisticResponseModel getStatisticResponseModelFromJson(String str) =>
    GetStatisticResponseModel.fromJson(json.decode(str));

class GetStatisticResponseModel extends BaseResponseModel {
  GetStatisticResponseModel({
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

  factory GetStatisticResponseModel.fromJson(Map<String, dynamic> json) =>
      GetStatisticResponseModel(
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
    required this.totalCollecting,
    required this.totalSale,
    required this.totalCompletedCr,
    required this.totalCancelCr,
  });

  final int totalCollecting;
  final int totalSale;
  final int totalCompletedCr;
  final int totalCancelCr;

  factory ResData.fromJson(Map<String, dynamic> json) => ResData(
        totalCollecting: json["totalCollecting"],
        totalSale: json["totalSale"],
        totalCompletedCr: json["totalCompletedCR"],
        totalCancelCr: json["totalCancelCR"],
      );
}
