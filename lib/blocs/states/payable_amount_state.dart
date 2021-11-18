part of '../payable_amount_bloc.dart';

class PayableAmountState extends Equatable {
  PayableAmountState({
    List<PayableAmount>? listPayableAmount,
    this.chosenIndex = 0,
    this.status = FormzStatus.pure,
  }) {
    this.listPayableAmount = listPayableAmount ?? [];
  }
  PayableAmountState copyWith({
    List<PayableAmount>? listPayableAmount,
    int? chosenIndex,
    FormzStatus? status,
  }) {
    return PayableAmountState(
      listPayableAmount: listPayableAmount ?? this.listPayableAmount,
      chosenIndex: chosenIndex ?? this.chosenIndex,
      status: status ?? this.status,
    );
  }

  late final List<PayableAmount> listPayableAmount;
  final int chosenIndex;
  final FormzStatus status;

  @override
  List<Object> get props => [
        listPayableAmount,
        chosenIndex,
        status,
      ];
}

class PayableAmount extends Equatable {
  PayableAmount({
    required this.id,
    required this.timePeriod,
    required this.dateTimeFrom,
    required this.dateTimeTo,
    required this.isFinished,
    required this.amount,
  });

  final String id;
  final String timePeriod;
  final DateTime dateTimeFrom;
  final DateTime dateTimeTo;
  final bool isFinished;
  final int amount;

  PayableAmount copyWith({
    String? id,
    String? timePeriod,
    DateTime? dateTimeFrom,
    DateTime? dateTimeTo,
    bool? isFinished,
    int? amount,
  }) {
    return PayableAmount(
      id: id ?? this.id,
      timePeriod: timePeriod ?? this.timePeriod,
      dateTimeFrom: dateTimeFrom ?? this.dateTimeFrom,
      dateTimeTo: dateTimeTo ?? this.dateTimeTo,
      isFinished: isFinished ?? this.isFinished,
      amount: amount ?? this.amount,
    );
  }

  @override
  List<Object> get props => [
        id,
        timePeriod,
        dateTimeFrom,
        dateTimeTo,
        isFinished,
        amount,
      ];
}
