import 'dart:convert';

import 'package:collector_app/providers/networks/models/response/base_response_model.dart';

ApproveResponseModel approveResponseModelFromJson(String str) =>
    ApproveResponseModel.fromJson(json.decode(str));

class ApproveResponseModel extends BaseResponseModel {
  ApproveResponseModel({
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

  String? msgCode;
  dynamic msgDetail;
  dynamic total;
  dynamic resData;

  factory ApproveResponseModel.fromJson(Map<String, dynamic> json) =>
      ApproveResponseModel(
        isSuccess: json["isSuccess"],
        statusCode: json["statusCode"],
        msgCode: json["msgCode"],
        msgDetail: json["msgDetail"],
        total: json["total"],
        resData: json["resData"],
      );
}
