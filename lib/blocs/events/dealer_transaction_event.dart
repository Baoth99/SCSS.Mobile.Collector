part of '../dealer_transaction_bloc.dart';

class DealerTransactionEvent extends AbstractEvent {
  const DealerTransactionEvent();
}

class DealerTransactionInitial extends DealerTransactionEvent {}

class DealerTransactionLoading extends DealerTransactionEvent {}

class DealerTransactionRefresh extends DealerTransactionEvent {}
