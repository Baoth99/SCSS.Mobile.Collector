part of '../seller_transaction_bloc.dart';

enum SellerTransactionStatus {
  pure,
  progress,
  completed,
  error,
  emptyList,
}

class SellerTransactionState extends Equatable {
  SellerTransactionState({
    List<SellerTransaction>? listSellerTransaction,
    this.status = SellerTransactionStatus.pure,
    this.page = 0,
    this.refreshStatus = RefreshStatus.idle,
    this.loadStatus = LoadStatus.idle,
  }) {
    this.listSellerTransaction = listSellerTransaction ?? [];
  }

  late final List<SellerTransaction> listSellerTransaction;
  final SellerTransactionStatus status;
  final int page;
  final RefreshStatus refreshStatus;
  final LoadStatus loadStatus;

  SellerTransactionState copyWith({
    List<SellerTransaction>? listSellerTransaction,
    SellerTransactionStatus? status,
    int? page,
    RefreshStatus? refreshStatus,
    LoadStatus? loadStatus,
  }) {
    return SellerTransactionState(
      listSellerTransaction:
          listSellerTransaction ?? this.listSellerTransaction,
      status: status ?? this.status,
      page: page ?? this.page,
      refreshStatus: refreshStatus ?? this.refreshStatus,
      loadStatus: loadStatus ?? this.loadStatus,
    );
  }

  @override
  List<Object> get props => [
        listSellerTransaction,
        status,
        page,
        refreshStatus,
        loadStatus,
      ];
}

class SellerTransaction extends Equatable {
  SellerTransaction({
    required this.id,
    required this.name,
    required this.time,
    required this.price,
    required this.status,
  });

  final String id;
  final String name;
  final String time;
  final int price;
  final int status;

  @override
  List<Object> get props => [
        id,
        name,
        time,
        price,
        status,
      ];
}
