import 'dart:convert';

import 'package:collector_app/providers/networks/models/response/base_response_model.dart';

SellerTransactionDetailResponseModel
    sellerTransactionDetailResponseModelFromJson(String str) =>
        SellerTransactionDetailResponseModel.fromJson(json.decode(str));

class SellerTransactionDetailResponseModel extends BaseResponseModel {
  SellerTransactionDetailResponseModel({
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

  factory SellerTransactionDetailResponseModel.fromJson(
          Map<String, dynamic> json) =>
      SellerTransactionDetailResponseModel(
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
    required this.collectingRequestCode,
    required this.status,
    required this.sellerName,
    required this.dayOfWeek,
    required this.date,
    required this.time,
    required this.complaint,
    this.items,
    this.total,
    this.transactionFee,
  });

  final String collectingRequestCode;
  final int status;
  final String sellerName;
  final int dayOfWeek;
  final String date;
  final String time;
  final Complaint complaint;
  final List<Item>? items;
  final int? total;
  final int? transactionFee;

  factory ResData.fromJson(Map<String, dynamic> json) => ResData(
        collectingRequestCode: json["collectingRequestCode"],
        status: json["status"],
        sellerName: json["sellerName"],
        dayOfWeek: json["dayOfWeek"],
        date: json["date"],
        time: json["time"],
        items: json["items"] == null
            ? null
            : List<Item>.from(json["items"].map((x) => Item.fromJson(x))),
        complaint: Complaint.fromJson(json["complaint"]),
        total: json["total"],
        transactionFee: json["transactionFee"],
      );
}

class Item {
  Item({
    this.scrapCategoryName,
    this.quantity,
    this.unit,
    required this.total,
  });

  String? scrapCategoryName;
  double? quantity;
  String? unit;
  int total;

  factory Item.fromJson(Map<String, dynamic> json) => Item(
        scrapCategoryName: json["scrapCategoryName"],
        quantity: json["quantity"]?.toDouble(),
        unit: json["unit"],
        total: json["total"],
      );
}

class Complaint {
  Complaint({
    this.complaintId,
    required this.complaintStatus,
    this.complaintContent,
    this.adminReply,
  });

  final String? complaintId;
  final int complaintStatus;
  final String? complaintContent;
  final String? adminReply;

  factory Complaint.fromJson(Map<String, dynamic> json) => Complaint(
        complaintId: json["complaintId"],
        complaintStatus: json["complaintStatus"],
        complaintContent: json["complaintContent"],
        adminReply: json["adminReply"],
      );
}
