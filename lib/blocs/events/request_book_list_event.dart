part of '../request_book_list_bloc.dart';

class RequestBookListEvent extends AbstractEvent {
  const RequestBookListEvent();
}

class RequestBookListInitial extends RequestBookListEvent {}

class RequestBookListLoading extends RequestBookListEvent {}

class RequestBookListRefresh extends RequestBookListEvent {}

class RequestBookIsApproved extends RequestBookListEvent {
  final String id;
  RequestBookIsApproved(this.id);
}
