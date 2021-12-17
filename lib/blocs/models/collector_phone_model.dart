// To parse this JSON data, do
//
//     final collectorPhoneResponseModel = collectorPhoneResponseModelFromJson(jsonString);

import 'dart:convert';

CollectorPhoneModel collectorPhoneResponseModelFromJson(String str) =>
    CollectorPhoneModel.fromJson(json.decode(str));

String collectorPhoneResponseModelToJson(CollectorPhoneModel data) =>
    json.encode(data.toJson());

class CollectorPhoneModel {
  CollectorPhoneModel({
    required this.id,
    required this.phone,
  });

  String id;
  String phone;

  factory CollectorPhoneModel.fromJson(Map<String, dynamic> json) =>
      CollectorPhoneModel(
        id: json["id"] == null ? null : json["id"],
        phone: json["phone"] == null ? null : json["phone"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "phone": phone,
      };
}
