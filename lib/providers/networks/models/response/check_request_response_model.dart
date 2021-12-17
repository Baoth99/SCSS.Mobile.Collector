import 'dart:convert';

import 'package:collector_app/providers/networks/models/response/base_response_model.dart';

CheckRequestApprovedResponseModel checkRequestApprovedResponseModelFromJson(
        String str) =>
    CheckRequestApprovedResponseModel.fromJson(json.decode(str));

class CheckRequestApprovedResponseModel extends BaseResponseModel {
  CheckRequestApprovedResponseModel({
    required bool isSuccess,
    required int statusCode,
    required this.msgCode,
    required this.msgDetail,
    required this.total,
    required this.resData,
  }) : super(
          isSuccess: isSuccess,
          statusCode: statusCode,
        );

  final dynamic msgCode;
  final dynamic msgDetail;
  final dynamic total;
  final ResData resData;

  factory CheckRequestApprovedResponseModel.fromJson(
          Map<String, dynamic> json) =>
      CheckRequestApprovedResponseModel(
        isSuccess: json["isSuccess"],
        statusCode: json["statusCode"],
        msgCode: json["msgCode"],
        msgDetail: json["msgDetail"],
        total: json["total"],
        resData: ResData.fromJson(json["resData"]),
      );
}

class ResData {
  ResData({
    required this.isApproved,
  });

  final bool isApproved;

  factory ResData.fromJson(Map<String, dynamic> json) => ResData(
        isApproved: json["isApproved"],
      );
}
