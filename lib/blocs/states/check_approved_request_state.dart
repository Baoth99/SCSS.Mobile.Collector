part of '../check_approved_request_bloc.dart';

class CheckApprovedRequestState extends Equatable {
  const CheckApprovedRequestState({
    this.id = Symbols.empty,
    this.isApprovedBySomebody = false,
    this.isApprovedByYou = false,
  });

  final String id;
  final bool isApprovedBySomebody;
  final bool isApprovedByYou;

  CheckApprovedRequestState copyWith({
    String? id,
    bool? isApprovedBySomebody,
    bool? isApprovedByYou,
  }) {
    return CheckApprovedRequestState(
      id: id ?? this.id,
      isApprovedBySomebody: isApprovedBySomebody ?? this.isApprovedBySomebody,
      isApprovedByYou: isApprovedByYou ?? this.isApprovedByYou,
    );
  }

  @override
  List<Object> get props => [
        id,
        isApprovedBySomebody,
        isApprovedByYou,
      ];
}
