part of '../feedback_admin_bloc.dart';

abstract class FeedbackAdminEvent extends AbstractEvent {
  const FeedbackAdminEvent();
}

class FeedbackAdminChanged extends FeedbackAdminEvent {
  const FeedbackAdminChanged(this.feedback);

  final String feedback;

  @override
  List<String> get props => [feedback];
}

class FeedbackAdminSubmmited extends FeedbackAdminEvent {}
