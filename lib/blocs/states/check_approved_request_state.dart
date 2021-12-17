part of '../check_approved_request_bloc.dart';

class CheckApprovedRequestState extends Equatable {
  const CheckApprovedRequestState({
    this.id = Symbols.empty,
    this.isApprovedBySomebody = false,
    this.isApprovedByYou = false,
    this.pendingRequestStatus = PendingRequestStatus.pending,
  });

  final String id;
  final bool isApprovedBySomebody;
  final bool isApprovedByYou;
  final PendingRequestStatus pendingRequestStatus;

  CheckApprovedRequestState copyWith({
    String? id,
    bool? isApprovedBySomebody,
    bool? isApprovedByYou,
    PendingRequestStatus? pendingRequestStatus,
  }) {
    return CheckApprovedRequestState(
      id: id ?? this.id,
      isApprovedBySomebody: isApprovedBySomebody ?? this.isApprovedBySomebody,
      isApprovedByYou: isApprovedByYou ?? this.isApprovedByYou,
      pendingRequestStatus: pendingRequestStatus ?? this.pendingRequestStatus,
    );
  }

  @override
  List<Object> get props => [
        id,
        isApprovedBySomebody,
        isApprovedByYou,
        pendingRequestStatus,
      ];
}
