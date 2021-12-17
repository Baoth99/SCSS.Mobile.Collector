import 'dart:convert';

RefreshTokenResponseModel refreshTokenResponseModelFromJson(String str) =>
    RefreshTokenResponseModel.fromJson(json.decode(str));

class RefreshTokenResponseModel {
  RefreshTokenResponseModel({
    this.idToken,
    this.accessToken,
    this.expiresIn,
    this.tokenType,
    this.refreshToken,
    this.scope,
  });

  String? idToken;
  String? accessToken;
  int? expiresIn;
  String? tokenType;
  String? refreshToken;
  String? scope;

  factory RefreshTokenResponseModel.fromJson(Map<String, dynamic> json) =>
      RefreshTokenResponseModel(
        idToken: json["id_token"],
        accessToken: json["access_token"],
        expiresIn: json["expires_in"],
        tokenType: json["token_type"],
        refreshToken: json["refresh_token"],
        scope: json["scope"],
      );
}
