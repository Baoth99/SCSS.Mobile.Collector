import 'dart:convert';

BaseResponseModel baseResponseModelFromJson(String str) =>
    BaseResponseModel.fromJson(json.decode(str));

class BaseResponseModel {
  bool? isSuccess;
  int? statusCode;

  BaseResponseModel({
    this.isSuccess,
    this.statusCode,
  });

  factory BaseResponseModel.fromJson(Map<String, dynamic> json) =>
      BaseResponseModel(
        isSuccess: json["isSuccess"],
        statusCode: json["statusCode"],
      );
}
