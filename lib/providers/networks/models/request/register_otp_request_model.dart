import 'dart:convert';

String registerOTPRequestModelToJson(RegisterOTPRequestModel data) =>
    json.encode(data.toJson());

class RegisterOTPRequestModel {
  RegisterOTPRequestModel({
    required this.phone,
  });

  String phone;

  Map<String, dynamic> toJson() => {
        "phone": phone,
      };
}
