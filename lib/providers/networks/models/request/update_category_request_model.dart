// To parse this JSON data, do
//
//     final updateScrapCategoryRequestModel = updateScrapCategoryRequestModelFromJson(jsonString);

import 'dart:convert';

import 'package:collector_app/blocs/models/scrap_category_detail_item_model.dart';
import 'package:collector_app/constants/text_constants.dart';

String updateScrapCategoryRequestModelToJson(
        UpdateScrapCategoryRequestModel data) =>
    json.encode(data.toJson());

class UpdateScrapCategoryRequestModel {
  UpdateScrapCategoryRequestModel({
    this.id = TextConstants.zeroId,
    required this.name,
    required this.imageUrl,
    required this.details,
  });

  String id;
  String name;
  String imageUrl;
  List<CategoryDetailItemModel> details;

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "imageUrl": imageUrl,
        "details": List<dynamic>.from(details.map((x) => x.toJson())),
      };
}
