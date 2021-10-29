import 'dart:convert';

import 'package:collector_app/providers/networks/models/response/base_response_model.dart';

CancelReasonResponseModel cancelReasonResponseModelFromJson(String str) =>
    CancelReasonResponseModel.fromJson(json.decode(str));

class CancelReasonResponseModel extends BaseResponseModel {
  CancelReasonResponseModel({
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
  List<String>? resData;

  factory CancelReasonResponseModel.fromJson(Map<String, dynamic> json) =>
      CancelReasonResponseModel(
        isSuccess: json["isSuccess"],
        statusCode: json["statusCode"],
        msgCode: json["msgCode"],
        msgDetail: json["msgDetail"],
        total: json["total"],
        resData: List<String>.from(json["resData"].map((x) => x)),
      );
}
