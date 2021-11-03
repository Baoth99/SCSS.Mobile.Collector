import 'dart:convert';

String createCollectDealTransactionRequestModelToJson(
        CreateCollectDealTransactionRequestModel data) =>
    json.encode(data.toJson());

class CreateCollectDealTransactionRequestModel {
  CreateCollectDealTransactionRequestModel({
    required this.collectDealTransactionId,
    required this.complaintContent,
  });

  String collectDealTransactionId;
  String complaintContent;

  Map<String, dynamic> toJson() => {
        "collectDealTransactionId": collectDealTransactionId,
        "complaintContent": complaintContent,
      };
}
