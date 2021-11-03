part of '../dealer_transaction_detail_bloc.dart';

class DealerTransactionDetailState extends Equatable {
  DealerTransactionDetailState({
    this.id = Symbols.empty,
    this.code = Symbols.empty,
    DateTime? transactionTime,
    this.dealerName = Symbols.empty,
    this.dealerPhone = Symbols.empty,
    this.dealerImageUrl = Symbols.empty,
    this.feedbackStatus = 0,
    this.ratingFeedback = 0,
    List<Item>? transaction,
    this.itemTotal = 0,
    this.totalBonus = 0,
    this.awardPoint = 0,
    this.billTotal = 0,
    this.complaint = const StateComplaint(),
    this.stateStatus = FormzStatus.pure,
  }) {
    this.transactionTime = transactionTime ?? DateTime.now();
    this.transaction = transaction ?? [];
  }

  final String id;
  final String code;
  late final DateTime transactionTime;
  final String dealerName;
  final String dealerPhone;
  final String dealerImageUrl;
  final int feedbackStatus;
  final double ratingFeedback;
  late final List<Item> transaction;
  final int itemTotal;
  final int totalBonus;
  final int awardPoint;
  final int billTotal;
  final StateComplaint complaint;
  final FormzStatus stateStatus;

  DealerTransactionDetailState copyWith({
    String? code,
    DateTime? transactionTime,
    String? dealerName,
    String? dealerPhone,
    String? dealerImageUrl,
    int? feedbackStatus,
    double? ratingFeedback,
    List<Item>? transaction,
    int? itemTotal,
    int? totalBonus,
    int? awardPoint,
    int? billTotal,
    StateComplaint? complaint,
    FormzStatus? stateStatus,
  }) {
    var state = DealerTransactionDetailState(
      id: id,
      code: code ?? this.code,
      transactionTime: transactionTime ?? this.transactionTime,
      dealerName: dealerName ?? this.dealerName,
      dealerPhone: dealerPhone ?? this.dealerPhone,
      dealerImageUrl: dealerImageUrl ?? this.dealerImageUrl,
      feedbackStatus: feedbackStatus ?? this.feedbackStatus,
      ratingFeedback: ratingFeedback ?? this.ratingFeedback,
      transaction: transaction ?? this.transaction,
      itemTotal: itemTotal ?? this.itemTotal,
      totalBonus: totalBonus ?? this.totalBonus,
      awardPoint: awardPoint ?? this.awardPoint,
      billTotal: billTotal ?? this.billTotal,
      complaint: complaint ?? this.complaint,
      stateStatus: stateStatus ?? this.stateStatus,
    );
    return state;
  }

  @override
  List<Object> get props => [
        code,
        transactionTime,
        dealerName,
        dealerPhone,
        dealerImageUrl,
        feedbackStatus,
        ratingFeedback,
        transaction,
        itemTotal,
        totalBonus,
        awardPoint,
        billTotal,
        complaint,
        stateStatus,
      ];
}

class Item extends Equatable {
  Item({
    this.name = Symbols.empty,
    this.unitInfo = '-',
    this.quantity = 0,
    this.total = 0,
    this.isBonus = false,
    this.bonusAmount = 0,
    this.promotionCode = Symbols.empty,
    this.promoAppliedBonus = 0,
  });
  final String name;
  final String unitInfo;
  final double quantity;
  final int total;
  final bool isBonus;
  final int bonusAmount;
  final String promotionCode;
  final int promoAppliedBonus;

  @override
  List<Object> get props => [
        name,
        unitInfo,
        quantity,
        total,
        isBonus,
        bonusAmount,
        promotionCode,
        promoAppliedBonus,
      ];
}

class StateComplaint extends Equatable {
  final int complaintStatus;
  final String complaintContent;
  final String adminReply;

  const StateComplaint({
    this.complaintStatus = 0,
    this.complaintContent = Symbols.empty,
    this.adminReply = Symbols.empty,
  });

  StateComplaint copyWith({
    int? complaintStatus,
    String? complaintContent,
    String? adminReply,
  }) {
    return StateComplaint(
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
