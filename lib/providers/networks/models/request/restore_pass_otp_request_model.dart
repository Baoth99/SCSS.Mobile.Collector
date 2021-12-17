import 'dart:convert';

String restorePassOtpRequestModelToJson(RestorePassOtpRequestModel data) =>
    json.encode(data.toJson());

class RestorePassOtpRequestModel {
  RestorePassOtpRequestModel({
    required this.phone,
  });

  String phone;

  Map<String, dynamic> toJson() => {
        "phone": phone,
      };
}
