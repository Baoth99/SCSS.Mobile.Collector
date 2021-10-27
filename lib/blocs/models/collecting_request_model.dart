import 'package:equatable/equatable.dart';

class CollectingRequestModel extends Equatable {
  CollectingRequestModel({
    required this.id,
    required this.collectingRequestCode,
    required this.sellerName,
    required this.sellerPhone,
    required this.dayOfWeek,
    required this.collectingRequestDate,
    required this.fromTime,
    required this.toTime,
    required this.collectingAddressName,
    required this.collectingAddress,
    required this.isBulky,
    required this.requestType,
    required this.distance,
    required this.distanceText,
    required this.durationTimeText,
    required this.durationTimeVal,
  });

  final String id;
  final String collectingRequestCode;
  final String sellerName;
  final String sellerPhone;
  final int dayOfWeek;
  final String collectingRequestDate;
  final String fromTime;
  final String toTime;
  final String collectingAddressName;
  final String collectingAddress;
  final bool isBulky;
  final int requestType;
  final int distance;
  final String distanceText;
  final String durationTimeText;
  final int durationTimeVal;

  @override
  List<Object> get props => [
        id,
        collectingRequestCode,
        sellerName,
        sellerPhone,
        dayOfWeek,
        collectingRequestDate,
        fromTime,
        toTime,
        collectingAddressName,
        collectingAddress,
        isBulky,
        requestType,
        distance,
        distanceText,
        durationTimeText,
        durationTimeVal,
      ];
}
