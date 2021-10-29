import 'dart:convert';

String cancelRequestRequestModelToJson(CancelRequestRequestModel data) =>
    json.encode(data.toJson());

class CancelRequestRequestModel {
  CancelRequestRequestModel({
    required this.id,
    required this.cancelReason,
  });

  String id;
  String cancelReason;

  Map<String, dynamic> toJson() => {
        "id": id,
        "cancelReason": cancelReason,
      };
}
