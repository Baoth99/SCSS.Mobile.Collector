part of '../promotion_bloc.dart';

class PromotionState extends Equatable {
  PromotionState({
    this.dealerId = Symbols.empty,
    List<PromotionModel>? listPromotion,
    this.status = FormzStatus.pure,
  }) {
    this.listPromotion = listPromotion ?? [];
  }

  final String dealerId;
  late final List<PromotionModel> listPromotion;
  final FormzStatus status;

  PromotionState copyWith({
    String? dealerId,
    int? total,
    List<PromotionModel>? listPromotion,
    FormzStatus? status,
  }) {
    return PromotionState(
      dealerId: dealerId ?? this.dealerId,
      listPromotion: listPromotion ?? this.listPromotion,
      status: status ?? this.status,
    );
  }

  @override
  List<Object> get props => [
        dealerId,
        listPromotion,
        status,
      ];
}

class PromotionModel extends Equatable {
  PromotionModel({
    required this.id,
    required this.code,
    required this.promotionName,
    required this.appliedScrapCategory,
    required this.appliedAmount,
    required this.bonusAmount,
    required this.appliedFromTime,
    required this.appliedToTime,
  });

  final String id;
  final String code;
  final String promotionName;
  final String appliedScrapCategory;
  final int appliedAmount;
  final int bonusAmount;
  final String appliedFromTime;
  final String appliedToTime;

  @override
  List<Object> get props => [
        id,
        code,
        promotionName,
        appliedScrapCategory,
        appliedAmount,
        bonusAmount,
        appliedFromTime,
        appliedToTime,
      ];
}
