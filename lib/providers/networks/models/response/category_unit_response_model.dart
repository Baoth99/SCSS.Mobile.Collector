// To parse this JSON data, do
//
//     final dealerResponseModel = dealerResponseModelFromJson(jsonString);

import 'dart:convert';

import 'package:collector_app/blocs/models/scrap_category_unit_model.dart';

ScrapCategoryUnitResponseModel dealerResponseModelFromJson(String str) =>
    ScrapCategoryUnitResponseModel.fromJson(json.decode(str));

class ScrapCategoryUnitResponseModel {
  ScrapCategoryUnitResponseModel({
    required this.isSuccess,
    required this.statusCode,
    this.msgCode,
    this.msgDetail,
    this.total,
    this.scrapCategoryDetailModels,
  });

  bool isSuccess;
  int statusCode;
  dynamic msgCode;
  dynamic msgDetail;
  dynamic total;
  List<ScrapCategoryUnitModel>? scrapCategoryDetailModels;

  factory ScrapCategoryUnitResponseModel.fromJson(Map<String, dynamic> json) =>
      ScrapCategoryUnitResponseModel(
        isSuccess: json["isSuccess"] == null ? null : json["isSuccess"],
        statusCode: json["statusCode"] == null ? null : json["statusCode"],
        msgCode: json["msgCode"],
        msgDetail: json["msgDetail"],
        total: json["total"],
        scrapCategoryDetailModels: json["resData"] == null
            ? null
            : List<ScrapCategoryUnitModel>.from(
                json["resData"].map((x) => ScrapCategoryUnitModel.fromJson(x))),
      );
}
