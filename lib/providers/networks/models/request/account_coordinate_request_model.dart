import 'dart:convert';

String accountCoordinateRequestModelToJson(
        AccountCoordinateRequestModel data) =>
    json.encode(data.toJson());

class AccountCoordinateRequestModel {
  AccountCoordinateRequestModel({
    required this.latitude,
    required this.longitude,
  });

  double latitude;
  double longitude;

  Map<String, dynamic> toJson() => {
        "latitude": latitude,
        "longitude": longitude,
      };
}
