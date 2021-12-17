part of '../dealer_transaction_detail_bloc.dart';

class DealerTransactionDetailEvent extends AbstractEvent {
  const DealerTransactionDetailEvent();
}

class DealerTransactionDetailInitial extends DealerTransactionDetailEvent {}

class DealerTransactionDetailAfterCanceled
    extends DealerTransactionDetailEvent {}
