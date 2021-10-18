import 'dart:convert';

String accountDeviceIdRequestModelToJson(AccountDeviceIdRequestModel data) =>
    json.encode(data.toJson());

class AccountDeviceIdRequestModel {
  AccountDeviceIdRequestModel({
    required this.deviceId,
  });

  String deviceId;
  Map<String, dynamic> toJson() => {
        "deviceId": deviceId,
      };
}
