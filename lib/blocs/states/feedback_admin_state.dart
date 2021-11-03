part of '../feedback_admin_bloc.dart';

class FeedbackAdminState extends Equatable {
  const FeedbackAdminState({
    this.requestId = Symbols.empty,
    this.feedbackAdmin = const FeedbackAdmin.pure(),
    required this.complaintType,
    this.status = FormzStatus.pure,
  });

  final String requestId;

  final FeedbackAdmin feedbackAdmin;
  final int complaintType;
  final FormzStatus status;

  FeedbackAdminState copyWith({
    FeedbackAdmin? feedbackAdmin,
    FormzStatus? status,
  }) {
    return FeedbackAdminState(
      requestId: requestId,
      feedbackAdmin: feedbackAdmin ?? this.feedbackAdmin,
      complaintType: complaintType,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [
        requestId,
        feedbackAdmin,
        complaintType,
        status,
      ];
}
