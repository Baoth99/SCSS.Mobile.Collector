import 'package:collector_app/constants/text_constants.dart';

class SellCollectTransactionDetailModel {
  String collectorCategoryId;
  String? collectorCategoryDetailId;
  int quantity;
  String? unit;
  int total;
  int price;

  bool isCalculatedByUnitPrice;
  bool isPromotionnApplied;

  int get totalCalculated {
    if (isCalculatedByUnitPrice && price != 0)
      return price * quantity;
    else
      return 0;
  }

  SellCollectTransactionDetailModel({
    required this.collectorCategoryId,
    this.collectorCategoryDetailId,
    required this.quantity,
    this.unit,
    required this.total,
    required this.price,
    required this.isCalculatedByUnitPrice,
    this.isPromotionnApplied = false,
  });

  Map<String, dynamic> toJson() => {
        "collectorCategoryDetailId": collectorCategoryDetailId == null
            ? TextConstants.zeroId
            : collectorCategoryDetailId,
        "quantity": quantity,
        "total": total,
        "price": price,
      };
}
