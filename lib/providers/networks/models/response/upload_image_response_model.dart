import 'dart:convert';

UploadImageResponseModel uploadImageResponseModelFromJson(String str) =>
    UploadImageResponseModel.fromJson(json.decode(str));

class UploadImageResponseModel {
  UploadImageResponseModel({
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
  String resData;

  factory UploadImageResponseModel.fromJson(Map<String, dynamic> json) =>
      UploadImageResponseModel(
        isSuccess: json["isSuccess"] == null ? null : json["isSuccess"],
        statusCode: json["statusCode"] == null ? null : json["statusCode"],
        msgCode: json["msgCode"],
        msgDetail: json["msgDetail"],
        total: json["total"],
        resData: json["resData"] == null ? null : json["resData"],
      );
}
