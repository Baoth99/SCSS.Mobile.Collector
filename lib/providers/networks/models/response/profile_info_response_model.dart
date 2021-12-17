import 'dart:convert';

import 'package:collector_app/providers/networks/models/response/base_response_model.dart';

ProfileInfoResponseModel profileInfoResponseModelFromJson(String str) =>
    ProfileInfoResponseModel.fromJson(json.decode(str));

class ProfileInfoResponseModel extends BaseResponseModel {
  ProfileInfoResponseModel({
    required bool isSuccess,
    required int statusCode,
    this.msgCode,
    this.msgDetail,
    this.total,
    this.resData,
  }) : super(
          isSuccess: isSuccess,
          statusCode: statusCode,
        );

  dynamic msgCode;
  dynamic msgDetail;
  dynamic total;
  ResData? resData;

  factory ProfileInfoResponseModel.fromJson(Map<String, dynamic> json) =>
      ProfileInfoResponseModel(
        isSuccess: json["isSuccess"],
        statusCode: json["statusCode"],
        msgCode: json["msgCode"],
        msgDetail: json["msgDetail"],
        total: json["total"],
        resData: ResData.fromJson(json["resData"]),
      );
}

class ResData {
  ResData({
    required this.id,
    this.name,
    this.userName,
    this.email,
    this.gender,
    this.phone,
    this.address,
    this.birthDate,
    this.image,
    this.roleKey,
    this.roleName,
    this.idCard,
    this.totalPoint,
    this.createdTime,
    this.status,
    this.rate,
  });

  String id;
  String? name;
  String? userName;
  String? email;
  int? gender;
  String? phone;
  String? address;
  String? birthDate;
  String? image;
  int? roleKey;
  String? roleName;
  String? idCard;
  int? totalPoint;
  String? createdTime;
  int? status;
  double? rate;

  factory ResData.fromJson(Map<String, dynamic> json) => ResData(
        id: json["id"],
        name: json["name"],
        userName: json["userName"],
        email: json["email"],
        gender: json["gender"],
        phone: json["phone"],
        address: json["address"],
        birthDate: json["birthDate"],
        image: json["image"],
        roleKey: json["roleKey"],
        roleName: json["roleName"],
        idCard: json["idCard"],
        totalPoint: json["totalPoint"],
        createdTime: json["createdTime"],
        status: json["status"],
        rate: json["rate"].toDouble(),
      );
}
