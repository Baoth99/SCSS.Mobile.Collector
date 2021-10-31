part of '../seller_transaction_detail_bloc.dart';

class SellerTransactionDetailEvent extends AbstractEvent {
  const SellerTransactionDetailEvent();
}

class SellerTransactionDetailInitial extends SellerTransactionDetailEvent {}

class SellerTransactionDetailAfterCanceled
    extends SellerTransactionDetailEvent {}
