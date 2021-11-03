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
    this.sellerPhone = Symbols.empty,
    this.time = Symbols.empty,
    this.area = Symbols.empty,
    this.collectingAddressName = Symbols.empty,
    this.collectingAddress = Symbols.empty,
    this.latitude = 0,
    this.longtitude = 0,
    this.isBulky = false,
    this.note = Symbols.empty,
    this.requestType = 0,
    this.isAllowedToApprove = false,
    this.status = FormzStatus.pure,
    required this.collectingRequestDetailStatus,
    this.approveEventStatus = ApproveEventStatus.pure,
    this.complaint = const RequestComplaint(),
  });

  final String id;
  final String collectingRequestCode;
  final String sellerName;
  final String sellerAvatarUrl;
  final Gender gender;
  final String scrapImageUrl;
  final String sellerPhone;
  final String time;
  final String area;
  final String collectingAddressName;
  final String collectingAddress;
  final double latitude;
  final double longtitude;
  final bool isBulky;
  final String note;
  final int requestType;
  final bool isAllowedToApprove;
  final FormzStatus status;
  final CollectingRequestDetailStatus collectingRequestDetailStatus;
  final ApproveEventStatus approveEventStatus;
  final RequestComplaint complaint;

  CollectingRequestDetailState copyWith({
    String? id,
    String? collectingRequestCode,
    String? sellerName,
    String? sellerAvatarUrl,
    Gender? gender,
    String? scrapImageUrl,
    String? sellerPhone,
    String? time,
    String? area,
    String? collectingAddressName,
    String? collectingAddress,
    double? latitude,
    double? longtitude,
    bool? isBulky,
    String? note,
    int? requestType,
    bool? isAllowedToApprove,
    FormzStatus? status,
    CollectingRequestDetailStatus? collectingRequestDetailStatus,
    ApproveEventStatus? approveEventStatus,
    RequestComplaint? complaint,
  }) {
    return CollectingRequestDetailState(
      id: id ?? this.id,
      collectingRequestCode:
          collectingRequestCode ?? this.collectingRequestCode,
      sellerName: sellerName ?? this.sellerName,
      sellerAvatarUrl: sellerAvatarUrl ?? this.sellerAvatarUrl,
      gender: gender ?? this.gender,
      scrapImageUrl: scrapImageUrl ?? this.scrapImageUrl,
      sellerPhone: sellerPhone ?? this.sellerPhone,
      time: time ?? this.time,
      area: area ?? this.area,
      collectingAddressName:
          collectingAddressName ?? this.collectingAddressName,
      collectingAddress: collectingAddress ?? this.collectingAddress,
      latitude: latitude ?? this.latitude,
      longtitude: longtitude ?? this.longtitude,
      isBulky: isBulky ?? this.isBulky,
      note: note ?? this.note,
      requestType: requestType ?? this.requestType,
      isAllowedToApprove: isAllowedToApprove ?? this.isAllowedToApprove,
      status: status ?? this.status,
      collectingRequestDetailStatus:
          collectingRequestDetailStatus ?? this.collectingRequestDetailStatus,
      approveEventStatus: approveEventStatus ?? this.approveEventStatus,
      complaint: complaint ?? this.complaint,
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
        sellerPhone,
        time,
        area,
        collectingAddressName,
        collectingAddress,
        latitude,
        longtitude,
        isBulky,
        note,
        requestType,
        isAllowedToApprove,
        status,
        collectingRequestDetailStatus,
        approveEventStatus,
        complaint,
      ];
}

class RequestComplaint extends Equatable {
  final int complaintStatus;
  final String complaintContent;
  final String adminReply;

  const RequestComplaint({
    this.complaintStatus = 0,
    this.complaintContent = Symbols.empty,
    this.adminReply = Symbols.empty,
  });

  RequestComplaint copyWith({
    int? complaintStatus,
    String? complaintContent,
    String? adminReply,
  }) {
    return RequestComplaint(
      complaintStatus: complaintStatus ?? this.complaintStatus,
      complaintContent: complaintContent ?? this.complaintContent,
      adminReply: adminReply ?? this.adminReply,
    );
  }

  @override
  List<Object> get props => [
        complaintStatus,
        complaintContent,
        adminReply,
      ];
}
