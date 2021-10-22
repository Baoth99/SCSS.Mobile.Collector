part of '../request_now_list_bloc.dart';

class RequestNowListEvent extends AbstractEvent {
  const RequestNowListEvent();
}

class RequestNowListInitial extends RequestNowListEvent {}

class RequestNowListLoading extends RequestNowListEvent {}

class RequestNowListRefresh extends RequestNowListEvent {}

class RequestNowIsApproved extends RequestNowListEvent {
  final String id;
  RequestNowIsApproved(this.id);
}
