// To parse this JSON data, do
//
//     final createSellCollectTransactionRequestModel = createSellCollectTransactionRequestModelFromJson(jsonString);

import 'dart:convert';

import 'package:collector_app/blocs/models/create_transaction_detail_model.dart';

String createSellCollectTransactionRequestModelToJson(
        CreateSellCollectTransactionRequestModel data) =>
    json.encode(data.toJson());

class CreateSellCollectTransactionRequestModel {
  CreateSellCollectTransactionRequestModel({
    required this.collectingRequestId,
    required this.transactionServiceFee,
    required this.total,
    required this.scrapCategoryItems,
  });

  String collectingRequestId;
  int transactionServiceFee;
  int total;
  List<SellCollectTransactionDetailModel> scrapCategoryItems;

  Map<String, dynamic> toJson() => {
        "collectingRequestId": collectingRequestId,
        "transactionServiceFee": transactionServiceFee,
        "total": total,
        "scrapCategoryItems":
            List<dynamic>.from(scrapCategoryItems.map((x) => x.toJson())),
      };
}
