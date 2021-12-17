part of '../dealer_transaction_bloc.dart';

enum DealerTransactionStatus {
  pure,
  progress,
  completed,
  error,
  emptyList,
}

class DealerTransactionState extends Equatable {
  DealerTransactionState({
    List<DealerTransaction>? listDealerTransaction,
    this.status = DealerTransactionStatus.pure,
    this.page = 0,
    this.refreshStatus = RefreshStatus.idle,
    this.loadStatus = LoadStatus.idle,
  }) {
    this.listDealerTransaction = listDealerTransaction ?? [];
  }

  late final List<DealerTransaction> listDealerTransaction;
  final DealerTransactionStatus status;
  final int page;
  final RefreshStatus refreshStatus;
  final LoadStatus loadStatus;

  DealerTransactionState copyWith({
    List<DealerTransaction>? listDealerTransaction,
    DealerTransactionStatus? status,
    int? page,
    RefreshStatus? refreshStatus,
    LoadStatus? loadStatus,
  }) {
    return DealerTransactionState(
      listDealerTransaction:
          listDealerTransaction ?? this.listDealerTransaction,
      status: status ?? this.status,
      page: page ?? this.page,
      refreshStatus: refreshStatus ?? this.refreshStatus,
      loadStatus: loadStatus ?? this.loadStatus,
    );
  }

  @override
  List<Object> get props => [
        listDealerTransaction,
        status,
        page,
        refreshStatus,
        loadStatus,
      ];
}

class DealerTransaction extends Equatable {
  DealerTransaction({
    required this.id,
    required this.dealerName,
    required this.dealerImage,
    required this.time,
    required this.price,
  });

  final String id;
  final String dealerName;
  final String dealerImage;
  final String time;
  final int price;

  @override
  List<Object> get props => [
        id,
        dealerName,
        dealerImage,
        time,
        price,
      ];
}
