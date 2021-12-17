import 'dart:convert';

String feedbackDealerTransactionRequestModelToJson(
        FeedbackDealerTransactionRequestModel data) =>
    json.encode(data.toJson());

class FeedbackDealerTransactionRequestModel {
  FeedbackDealerTransactionRequestModel({
    required this.collectDealTransId,
    required this.rate,
    required this.review,
  });

  final String collectDealTransId;
  final double rate;
  final String review;

  Map<String, dynamic> toJson() => {
        "collectDealTransId": collectDealTransId,
        "rate": rate,
        "review": review,
      };
}
