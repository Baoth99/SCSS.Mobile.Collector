import 'package:collector_app/constants/text_constants.dart';

class CategoryDetailItemModel {
  CategoryDetailItemModel({
    required this.id,
    required this.unit,
    required this.price,
    required this.status,
  });

  CategoryDetailItemModel.updateCategoryModel({
    this.id = TextConstants.zeroId,
    required this.unit,
    this.price = 0,
    status,
  }) : status = status ?? Status.ACTIVE.number;

  String id;
  String unit;
  int price;
  int status;

  factory CategoryDetailItemModel.fromJson(Map<String, dynamic> json) =>
      CategoryDetailItemModel(
        id: json["id"] == null ? null : json["id"],
        unit: json["unit"] == null ? null : json["unit"],
        price: json["price"] == null ? null : json["price"],
        status: json["status"] == null ? null : json["status"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "unit": unit,
        "price": price,
        "status": status,
      };
}

enum Status {
  ACTIVE,
  DEACTIVE,
}

extension StatusExtension on Status {
  int get number {
    switch (this) {
      case Status.ACTIVE:
        return 1;
      case Status.DEACTIVE:
        return 2;
    }
  }
}
