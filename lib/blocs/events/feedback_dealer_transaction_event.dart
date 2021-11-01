part of '../feedback_dealer_transaction_bloc.dart';

abstract class FeedbackDealerTransactionEvent extends AbstractEvent {
  const FeedbackDealerTransactionEvent();
}

class FeedbackDealerReviewChanged extends FeedbackDealerTransactionEvent {
  const FeedbackDealerReviewChanged(this.review);

  final String review;

  @override
  List<String> get props => [review];
}

class FeedbackDealerRateChanged extends FeedbackDealerTransactionEvent {
  const FeedbackDealerRateChanged(this.rate);

  final double rate;

  @override
  List<double> get props => [rate];
}

class FeedbackDealerTransactionSubmmited
    extends FeedbackDealerTransactionEvent {}
