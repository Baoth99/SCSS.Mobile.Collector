import 'package:collector_app/constants/text_constants.dart';
import 'package:flutter/material.dart';

class ScrapCategoryModel {
  ScrapCategoryModel.createTransactionModel({
    required this.id,
    required this.name,
    this.promotionId,
    this.promotionCode,
    required this.appliedAmount,
    required this.bonusAmount,
    this.imageUrl = TextConstants.emptyString,
    this.unit = TextConstants.emptyString,
    this.price = 0,
  });

  ScrapCategoryModel.categoryListModel({
    required this.id,
    required this.name,
    this.imageUrl = TextConstants.emptyString,
    this.image,
    this.unit = TextConstants.emptyString,
    this.price = 0,
  });

  ScrapCategoryModel.createCategoryModel({
    this.id = TextConstants.emptyString,
    this.name = TextConstants.emptyString,
    this.imageUrl = TextConstants.emptyString,
    this.image,
    required this.unit,
    required this.price,
  });

  String id;
  String name;
  dynamic promotionId;
  dynamic promotionCode;
  dynamic appliedAmount;
  dynamic bonusAmount;
  String imageUrl;
  ImageProvider? image;
  String unit;
  int price;

  factory ScrapCategoryModel.fromJsonToCreateTransactionModel(
          Map<String, dynamic> json) =>
      ScrapCategoryModel.createTransactionModel(
        id: json["id"] == null ? null : json["id"],
        name: json["name"] == null ? null : json["name"],
        promotionId: json["promotionId"],
        promotionCode: json["promotionCode"],
        appliedAmount: json["appliedAmount"],
        bonusAmount: json["bonusAmount"],
      );

  factory ScrapCategoryModel.fromJsonToCategoryListModel(
          Map<String, dynamic> json) =>
      ScrapCategoryModel.categoryListModel(
        id: json["id"],
        name: json["name"],
        imageUrl: json['imageUrl'],
      );

  Map<String, dynamic> createCategoryModelToJson() => {
        "unit": unit,
        "price": price,
      };
}
