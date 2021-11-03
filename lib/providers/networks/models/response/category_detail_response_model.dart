// To parse this JSON data, do
//
//     final scrapCategoryDetailResponseModel = scrapCategoryDetailResponseModelFromJson(jsonString);

import 'dart:convert';

import 'package:collector_app/blocs/models/scrap_category_detail_model.dart';

ScrapCategoryDetailResponseModel scrapCategoryDetailResponseModelFromJson(
        String str) =>
    ScrapCategoryDetailResponseModel.fromJson(json.decode(str));

String scrapCategoryDetailResponseModelToJson(
        ScrapCategoryDetailResponseModel data) =>
    json.encode(data.toJson());

class ScrapCategoryDetailResponseModel {
  ScrapCategoryDetailResponseModel({
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
  ScrapCategoryDetailModel resData;

  factory ScrapCategoryDetailResponseModel.fromJson(
          Map<String, dynamic> json) =>
      ScrapCategoryDetailResponseModel(
        isSuccess: json["isSuccess"] == null ? null : json["isSuccess"],
        statusCode: json["statusCode"] == null ? null : json["statusCode"],
        msgCode: json["msgCode"],
        msgDetail: json["msgDetail"],
        total: json["total"],
        resData: ScrapCategoryDetailModel.fromJson(json["resData"]),
      );

  Map<String, dynamic> toJson() => {
        "isSuccess": isSuccess,
        "statusCode": statusCode,
        "msgCode": msgCode,
        "msgDetail": msgDetail,
        "total": total,
        "resData": resData.toJson(),
      };
}
