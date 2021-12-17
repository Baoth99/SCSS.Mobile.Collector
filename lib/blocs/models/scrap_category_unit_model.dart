// To parse this JSON data, do
//
//     final scrapCategoryDetailModel = scrapCategoryDetailModelFromJson(jsonString);

import 'dart:convert';

ScrapCategoryUnitModel scrapCategoryDetailModelFromJson(String str) =>
    ScrapCategoryUnitModel.fromJson(json.decode(str));

String scrapCategoryDetailModelToJson(ScrapCategoryUnitModel data) =>
    json.encode(data.toJson());

class ScrapCategoryUnitModel {
  ScrapCategoryUnitModel({
    required this.id,
    required this.unit,
    required this.price,
  });

  String id;
  String unit;
  int price;

  factory ScrapCategoryUnitModel.fromJson(Map<String, dynamic> json) =>
      ScrapCategoryUnitModel(
        id: json["id"] == null ? null : json["id"],
        unit: json["unit"] == null ? null : json["unit"],
        price: json["price"] == null ? null : json["price"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "unit": unit,
        "price": price,
      };
}

class ScrapCategoryDetailModelTemp {
  int id;
  int scrapCategoryId;
  String unit;
  int? price;
  int createdBy;
  DateTime createdTime;
  int status;
  int updatedBy;
  DateTime updatedTime;

  ScrapCategoryDetailModelTemp({
    required int id,
    required int scrapCategoryId,
    required String unit,
    int? price,
    required int createdBy,
    required DateTime createdTime,
    required int status,
    required int updatedBy,
    required DateTime updatedTime,
  })  : id = id,
        scrapCategoryId = scrapCategoryId,
        unit = unit,
        price = price,
        createdBy = createdBy,
        createdTime = createdTime,
        status = status,
        updatedBy = updatedBy,
        updatedTime = updatedTime;

  int get getId => this.id;

  set setId(int id) => this.id = id;

  get getScrapCategoryId => this.scrapCategoryId;

  set setScrapCategoryId(scrapCategoryId) =>
      this.scrapCategoryId = scrapCategoryId;

  get getUnit => this.unit;

  set setUnit(unit) => this.unit = unit;

  get getPrice => this.price;

  set setPrice(price) => this.price = price;

  get getCreatedBy => this.createdBy;

  set setCreatedBy(createdBy) => this.createdBy = createdBy;

  get getCreatedTime => this.createdTime;

  set setCreatedTime(createdTime) => this.createdTime = createdTime;

  get getStatus => this.status;

  set setStatus(status) => this.status = status;

  get getUpdatedBy => this.updatedBy;

  set setUpdatedBy(updatedBy) => this.updatedBy = updatedBy;

  get getUpdatedTime => this.updatedTime;

  set setUpdatedTime(updatedTime) => this.updatedTime = updatedTime;
}
