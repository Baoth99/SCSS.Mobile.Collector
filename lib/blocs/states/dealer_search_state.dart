part of '../dealer_search_bloc.dart';

class DealerSearchState extends Equatable {
  late final List<DealerInfo> listDealers;
  final FormzStatus status;

  DealerSearchState({
    List<DealerInfo>? listDealers,
    this.status = FormzStatus.pure,
  }) {
    this.listDealers = listDealers ?? [];
  }

  DealerSearchState copyWith({
    List<DealerInfo>? listDealers,
    FormzStatus? status,
  }) {
    return DealerSearchState(
      listDealers: listDealers ?? this.listDealers,
      status: status ?? this.status,
    );
  }

  @override
  List<Object> get props => [
        listDealers,
        status,
      ];
}

class DealerInfo extends Equatable {
  const DealerInfo({
    required this.dealerId,
    required this.dealerName,
    required this.isActive,
    required this.dealerAddress,
    required this.latitude,
    required this.longtitude,
    required this.dealerImageUrl,
    required this.openTime,
    required this.closeTime,
    required this.distance,
    required this.distanceText,
  });

  final String dealerId;
  final String dealerName;
  final bool isActive;
  final String dealerAddress;
  final double latitude;
  final double longtitude;
  final String dealerImageUrl;
  final String openTime;
  final String closeTime;
  final int distance;
  final String distanceText;

  @override
  List<Object> get props => [
        dealerId,
        dealerName,
        isActive,
        dealerAddress,
        latitude,
        longtitude,
        dealerImageUrl,
        openTime,
        closeTime,
        distance,
        distanceText,
      ];
}
