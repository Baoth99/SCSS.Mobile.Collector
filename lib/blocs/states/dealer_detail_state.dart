part of '../dealer_detail_bloc.dart';

class DealerDetailState extends Equatable {
  const DealerDetailState({
    this.id = Symbols.empty,
    this.dealerName = Symbols.empty,
    this.dealerImageUrl = Symbols.empty,
    this.dealerPhone = Symbols.empty,
    this.rate = 0,
    this.openTime = Symbols.empty,
    this.closeTime = Symbols.empty,
    this.dealerAddress = Symbols.empty,
    this.latitude = 0,
    this.longtitude = 0,
    this.status = FormzStatus.pure,
  });
  final String id;
  final String dealerName;
  final String dealerImageUrl;
  final String dealerPhone;
  final double rate;
  final String openTime;
  final String closeTime;
  final String dealerAddress;
  final double? latitude;
  final double? longtitude;
  final FormzStatus status;

  DealerDetailState copyWith({
    String? id,
    String? dealerName,
    String? dealerImageUrl,
    String? dealerPhone,
    double? rate,
    String? openTime,
    String? closeTime,
    String? dealerAddress,
    double? latitude,
    double? longtitude,
    FormzStatus? status,
  }) {
    return DealerDetailState(
      id: id ?? this.id,
      dealerName: dealerName ?? this.dealerName,
      dealerImageUrl: dealerImageUrl ?? this.dealerImageUrl,
      dealerPhone: dealerPhone ?? this.dealerPhone,
      rate: rate ?? this.rate,
      openTime: openTime ?? this.openTime,
      closeTime: closeTime ?? this.closeTime,
      dealerAddress: dealerAddress ?? this.dealerAddress,
      latitude: latitude ?? this.latitude,
      longtitude: longtitude ?? this.longtitude,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [
    id,
    dealerName,
    dealerImageUrl,
    dealerPhone,
    rate,
    openTime,
    closeTime,
    dealerAddress,
    latitude,
    longtitude,
    status,
  ];
}