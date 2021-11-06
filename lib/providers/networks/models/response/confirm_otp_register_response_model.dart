import 'dart:convert';

import 'package:collector_app/providers/networks/models/response/base_response_model.dart';

ConfirmOTPRegisterResponseModel confirmOTPRegisterResponseModelFromJson(
        String str) =>
    ConfirmOTPRegisterResponseModel.fromJson(json.decode(str));

class ConfirmOTPRegisterResponseModel extends BaseResponseModel {
  ConfirmOTPRegisterResponseModel({
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
  dynamic total;
  String? resData;

  factory ConfirmOTPRegisterResponseModel.fromJson(Map<String, dynamic> json) =>
      ConfirmOTPRegisterResponseModel(
        isSuccess: json["isSuccess"],
        statusCode: json["statusCode"],
        msgCode: json["msgCode"],
        msgDetail: json["msgDetail"],
        total: json["total"],
        resData: json["resData"],
      );
}
