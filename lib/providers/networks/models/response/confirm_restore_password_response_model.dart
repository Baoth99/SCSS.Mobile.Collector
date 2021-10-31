import 'dart:convert';

import 'package:collector_app/providers/networks/models/response/base_response_model.dart';

ConfirmRestorePasswordResponseModel confirmRestorePasswordResponseModelFromJson(
        String str) =>
    ConfirmRestorePasswordResponseModel.fromJson(json.decode(str));

class ConfirmRestorePasswordResponseModel extends BaseResponseModel {
  ConfirmRestorePasswordResponseModel({
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

  factory ConfirmRestorePasswordResponseModel.fromJson(
          Map<String, dynamic> json) =>
      ConfirmRestorePasswordResponseModel(
        isSuccess: json["isSuccess"],
        statusCode: json["statusCode"],
        msgCode: json["msgCode"],
        msgDetail: json["msgDetail"],
        total: json["total"],
        resData: json["resData"],
      );
}
