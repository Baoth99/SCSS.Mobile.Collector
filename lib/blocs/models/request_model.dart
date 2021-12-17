import 'package:collector_app/constants/constants.dart';
import 'package:equatable/equatable.dart';

class Request extends Equatable {
  Request({
    required this.id,
    required this.collectingRequestCode,
    required this.sellerName,
    required this.dayOfWeek,
    required this.collectingRequestDate,
    required this.fromTime,
    required this.toTime,
    required this.area,
    required this.durationTimeText,
    required this.durationTimeVal,
    required this.latitude,
    required this.longtitude,
    required this.isBulky,
    required this.requestType,
    required this.distance,
    required this.distanceText,
    this.pendingRequestStatus = PendingRequestStatus.pending,
  });

  String id;
  String collectingRequestCode;
  String sellerName;
  int dayOfWeek;
  DateTime collectingRequestDate;
  String fromTime;
  String toTime;
  String area;
  String durationTimeText;
  int durationTimeVal;
  double latitude;
  double longtitude;
  bool isBulky;
  int requestType;
  int distance;
  String distanceText;
  PendingRequestStatus pendingRequestStatus;

  @override
  List<Object> get props => [
        id,
        collectingRequestCode,
        sellerName,
        dayOfWeek,
        collectingRequestDate,
        fromTime,
        toTime,
        area,
        durationTimeText,
        durationTimeVal,
        latitude,
        longtitude,
        isBulky,
        requestType,
        distance,
        distanceText,
        pendingRequestStatus,
      ];
}
