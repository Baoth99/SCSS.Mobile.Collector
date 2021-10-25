part of '../collecting_request_detail_bloc.dart';

class CollectingRequestType {
  static const now = 1;
  static const book = 2;
  static const convert = 3;
}

enum CollectingRequestDetailStatus {
  pending,
  approved,
}

enum ApproveEventStatus {
  pure,
  success,
  approvedByOther,
}

class CollectingRequestDetailState extends Equatable {
  const CollectingRequestDetailState({
    this.id = Symbols.empty,
    this.collectingRequestCode = Symbols.empty,
    this.sellerName = Symbols.empty,
    this.sellerAvatarUrl = Symbols.empty,
    this.gender = Gender.male,
    this.scrapImageUrl = Symbols.empty,
    this.time = Symbols.empty,
    this.area = Symbols.empty,
    this.latitude = 0,
    this.longtitude = 0,
    this.isBulky = false,
    this.note = Symbols.empty,
    this.requestType = 0,
    this.isAllowedToApprove = false,
    this.status = FormzStatus.pure,
    required this.collectingRequestDetailStatus,
    this.approveEventStatus = ApproveEventStatus.pure,
  });

  final String id;
  final String collectingRequestCode;
  final String sellerName;
  final String sellerAvatarUrl;
  final Gender gender;
  final String scrapImageUrl;
  final String time;
  final String area;
  final double latitude;
  final double longtitude;
  final bool isBulky;
  final String note;
  final int requestType;
  final bool isAllowedToApprove;
  final FormzStatus status;
  final CollectingRequestDetailStatus collectingRequestDetailStatus;
  final ApproveEventStatus approveEventStatus;

  CollectingRequestDetailState copyWith({
    String? id,
    String? collectingRequestCode,
    String? sellerName,
    String? sellerAvatarUrl,
    Gender? gender,
    String? scrapImageUrl,
    String? time,
    String? area,
    double? latitude,
    double? longtitude,
    bool? isBulky,
    String? note,
    int? requestType,
    bool? isAllowedToApprove,
    FormzStatus? status,
    ApproveEventStatus? approveEventStatus,
  }) {
    return CollectingRequestDetailState(
      id: id ?? this.id,
      collectingRequestCode:
          collectingRequestCode ?? this.collectingRequestCode,
      sellerName: sellerName ?? this.sellerName,
      sellerAvatarUrl: sellerAvatarUrl ?? this.sellerAvatarUrl,
      gender: gender ?? this.gender,
      scrapImageUrl: scrapImageUrl ?? this.scrapImageUrl,
      time: time ?? this.time,
      area: area ?? this.area,
      latitude: latitude ?? this.latitude,
      longtitude: longtitude ?? this.longtitude,
      isBulky: isBulky ?? this.isBulky,
      note: note ?? this.note,
      requestType: requestType ?? this.requestType,
      isAllowedToApprove: isAllowedToApprove ?? this.isAllowedToApprove,
      status: status ?? this.status,
      collectingRequestDetailStatus: this.collectingRequestDetailStatus,
      approveEventStatus: approveEventStatus ?? this.approveEventStatus,
    );
  }

  @override
  List<Object> get props => [
        id,
        collectingRequestCode,
        sellerName,
        sellerAvatarUrl,
        gender,
        scrapImageUrl,
        time,
        area,
        latitude,
        longtitude,
        isBulky,
        note,
        requestType,
        isAllowedToApprove,
        status,
        collectingRequestDetailStatus,
        approveEventStatus,
      ];
}
