part of '../payable_amount_bloc.dart';

abstract class PayableAmountEvent extends AbstractEvent {
  const PayableAmountEvent();
}

class PayableAmountGet extends PayableAmountEvent {}

class PayableMonthChanged extends PayableAmountEvent {
  final PayableAmount model;
  PayableMonthChanged(this.model);
}
