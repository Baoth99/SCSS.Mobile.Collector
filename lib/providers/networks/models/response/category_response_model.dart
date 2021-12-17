import 'dart:convert';

import 'package:collector_app/blocs/models/scrap_category_model.dart';

ScrapCategoryResponseModel responseModelFromJsonToCategoryListModel(
        String str) =>
    ScrapCategoryResponseModel.fromJsonToCategoryListModel(json.decode(str));

// String responseModelToJson(
//         ScrapCategoryResponseModel data) =>
//     json.encode(data.toJson());

class ScrapCategoryResponseModel {
  ScrapCategoryResponseModel({
    required this.isSuccess,
    required this.statusCode,
    required this.msgCode,
    required this.msgDetail,
    required this.total,
    required this.scrapCategoryModels,
  });

  bool isSuccess;
  int statusCode;
  dynamic msgCode;
  dynamic msgDetail;
  dynamic total;
  List<ScrapCategoryModel> scrapCategoryModels;

  factory ScrapCategoryResponseModel.fromJsonToCreateTransactionModel(
          Map<String, dynamic> json) =>
      ScrapCategoryResponseModel(
        isSuccess: json["isSuccess"] == null ? null : json["isSuccess"],
        statusCode: json["statusCode"] == null ? null : json["statusCode"],
        msgCode: json["msgCode"],
        msgDetail: json["msgDetail"],
        total: json["total"],
        scrapCategoryModels: List<ScrapCategoryModel>.from(json["resData"].map(
            (x) => ScrapCategoryModel.fromJsonToCreateTransactionModel(x))),
      );

  factory ScrapCategoryResponseModel.fromJsonToCategoryListModel(
          Map<String, dynamic> json) =>
      ScrapCategoryResponseModel(
        isSuccess: json["isSuccess"] == null ? null : json["isSuccess"],
        statusCode: json["statusCode"] == null ? null : json["statusCode"],
        msgCode: json["msgCode"],
        msgDetail: json["msgDetail"],
        total: json["total"],
        scrapCategoryModels: List<ScrapCategoryModel>.from(json["resData"]
            .map((x) => ScrapCategoryModel.fromJsonToCategoryListModel(x))),
      );
}
