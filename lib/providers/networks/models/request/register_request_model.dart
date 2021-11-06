import 'dart:convert';

String registerRequestModelToJson(RegisterRequestModel data) =>
    json.encode(data.toJson());

class RegisterRequestModel {
  RegisterRequestModel({
    required this.registerToken,
    required this.userName,
    required this.password,
    required this.name,
    required this.gender,
    required this.deviceId,
  });

  String registerToken;
  String userName;
  String password;
  String name;
  int gender;
  String deviceId;

  Map<String, dynamic> toJson() => {
        "registerToken": registerToken,
        "userName": userName,
        "password": password,
        "name": name,
        "gender": gender,
        "deviceId": deviceId,
      };
}
