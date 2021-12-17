import 'dart:convert';

import 'package:collector_app/blocs/models/scrap_category_model.dart';
import 'package:collector_app/constants/text_constants.dart';

String createScrapCategoryRequestModelToJson(
        CreateScrapCategoryRequestModel data) =>
    json.encode(data.toJson());

class CreateScrapCategoryRequestModel {
  CreateScrapCategoryRequestModel({
    this.id = TextConstants.emptyString,
    required this.name,
    required this.imageUrl,
    required this.details,
  });

  String id;
  String name;
  String imageUrl;
  List<ScrapCategoryModel> details;

  Map<String, dynamic> toJson() => {
        "name": name,
        "imageUrl": imageUrl,
        "details": List<dynamic>.from(
            details.map((x) => x.createCategoryModelToJson())),
      };
}
