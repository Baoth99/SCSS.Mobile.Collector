import 'dart:convert';

String sellCollectComplaintRequestModelToJson(
        SellCollectComplaintRequestModel data) =>
    json.encode(data.toJson());

class SellCollectComplaintRequestModel {
  SellCollectComplaintRequestModel({
    required this.collectingRequestId,
    required this.complaintContent,
  });

  String collectingRequestId;
  String complaintContent;

  Map<String, dynamic> toJson() => {
        "collectingRequestId": collectingRequestId,
        "complaintContent": complaintContent,
      };
}
