part of '../seller_transaction_detail_bloc.dart';

class SellerTransactionDetailState extends Equatable {
  SellerTransactionDetailState({
    this.id = Symbols.empty,
    this.collectingRequestCode = Symbols.empty,
    this.sellerName = Symbols.empty,
    this.doneActivityTime = Symbols.empty,
    List<TransactionItem>? transaction,
    this.itemTotal = 0,
    this.serviceFee = 0,
    this.billTotal = 0,
    this.status = 0,
    this.complaint = const SellerComplaint(),
    this.stateStatus = FormzStatus.pure,
  }) {
    this.transaction = transaction ?? [];
  }

  final String id;
  final String collectingRequestCode;
  final String sellerName;
  final String doneActivityTime;
  late final List<TransactionItem> transaction;
  final int itemTotal;
  final int serviceFee;
  final int billTotal;
  final int status;
  final SellerComplaint complaint;
  final FormzStatus stateStatus;

  SellerTransactionDetailState copyWith({
    String? collectingRequestCode,
    String? sellerName,
    String? doneActivityTime,
    List<TransactionItem>? transaction,
    int? itemTotal,
    int? serviceFee,
    int? billTotal,
    int? status,
    SellerComplaint? complaint,
    FormzStatus? stateStatus,
  }) {
    var state = SellerTransactionDetailState(
      id: id,
      collectingRequestCode:
          collectingRequestCode ?? this.collectingRequestCode,
      sellerName: sellerName ?? this.sellerName,
      doneActivityTime: doneActivityTime ?? this.doneActivityTime,
      transaction: transaction ?? this.transaction,
      itemTotal: itemTotal ?? this.itemTotal,
      serviceFee: serviceFee ?? this.serviceFee,
      billTotal: billTotal ?? this.billTotal,
      status: status ?? this.status,
      complaint: complaint ?? this.complaint,
      stateStatus: stateStatus ?? this.stateStatus,
    );
    return state;
  }

  @override
  List<Object> get props => [
        id,
        collectingRequestCode,
        sellerName,
        doneActivityTime,
        transaction,
        itemTotal,
        serviceFee,
        billTotal,
        status,
        complaint,
        stateStatus,
      ];
}

class TransactionItem extends Equatable {
  TransactionItem({
    this.name = Symbols.empty,
    this.unitInfo = '-',
    this.quantity = 0,
    required this.total,
  });
  final String name;
  final String unitInfo;
  final double quantity;
  final int total;

  @override
  List<Object> get props => [
        name,
        unitInfo,
        quantity,
        total,
      ];
}

class SellerComplaint extends Equatable {
  final int complaintStatus;
  final String complaintContent;
  final String adminReply;

  const SellerComplaint({
    this.complaintStatus = 0,
    this.complaintContent = Symbols.empty,
    this.adminReply = Symbols.empty,
  });

  SellerComplaint copyWith({
    int? complaintStatus,
    String? complaintContent,
    String? adminReply,
  }) {
    return SellerComplaint(
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
