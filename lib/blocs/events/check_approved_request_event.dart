part of '../check_approved_request_bloc.dart';

abstract class CheckApprovedRequestEvent extends Equatable {}

class CheckRequestApproved extends CheckApprovedRequestEvent {
  @override
  List<Object> get props => [];
}

class ChangeRequestApprovedByYou extends CheckApprovedRequestEvent {
  @override
  List<Object> get props => [];
}

class RefershCheckApproved extends CheckApprovedRequestEvent {
  RefershCheckApproved();

  @override
  List<Object> get props => [];
}

class AddIdCheckApprove extends CheckApprovedRequestEvent {
  final String id;
  AddIdCheckApprove(this.id);

  @override
  List<Object> get props => [id];
}

class CheckRequestStatusRealTime extends CheckApprovedRequestEvent {
  final CollectingRequestNoticeModel model;
  CheckRequestStatusRealTime(this.model);

  @override
  List<Object> get props => [model];
}

class ApproveCheckApproved extends CheckApprovedRequestEvent {
  @override
  List<Object> get props => [];
}
