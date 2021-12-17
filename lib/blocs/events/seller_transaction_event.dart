part of '../seller_transaction_bloc.dart';

class SellerTransactionEvent extends AbstractEvent {
  const SellerTransactionEvent();
}

class SellerTransactionInitial extends SellerTransactionEvent {}

class SellerTransactionLoading extends SellerTransactionEvent {}

class SellerTransactionRefresh extends SellerTransactionEvent {}
