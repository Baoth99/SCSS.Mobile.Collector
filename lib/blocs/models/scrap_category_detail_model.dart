import 'scrap_category_detail_item_model.dart';

class ScrapCategoryDetailModel {
  ScrapCategoryDetailModel({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.details,
  });

  String id;
  String name;
  String imageUrl;
  List<CategoryDetailItemModel> details;

  factory ScrapCategoryDetailModel.fromJson(Map<String, dynamic> json) =>
      ScrapCategoryDetailModel(
        id: json["id"] == null ? null : json["id"],
        name: json["name"] == null ? null : json["name"],
        imageUrl: json["imageUrl"] == null ? null : json["imageUrl"],
        details: List<CategoryDetailItemModel>.from(
            json["details"].map((x) => CategoryDetailItemModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "imageUrl": imageUrl,
        "details": List<dynamic>.from(details.map((x) => x.toJson())),
      };
}
