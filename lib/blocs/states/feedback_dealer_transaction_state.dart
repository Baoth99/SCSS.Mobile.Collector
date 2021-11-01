part of '../feedback_dealer_transaction_bloc.dart';

class FeedbackDealerTransactionState extends Equatable {
  const FeedbackDealerTransactionState({
    required this.transactionId,
    required this.rate,
    this.review = Symbols.empty,
    this.status = FormzStatus.pure,
  });

  final String transactionId;
  final double rate;
  final String review;
  final FormzStatus status;

  FeedbackDealerTransactionState copyWith({
    double? rate,
    String? review,
    FormzStatus? status,
  }) {
    return FeedbackDealerTransactionState(
      transactionId: transactionId,
      rate: rate ?? this.rate,
      review: review ?? this.review,
      status: status ?? this.status,
    );
  }

  @override
  List<Object> get props => [
        transactionId,
        rate,
        review,
        status,
      ];
}
