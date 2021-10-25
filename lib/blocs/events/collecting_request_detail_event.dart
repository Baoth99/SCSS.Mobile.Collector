part of '../collecting_request_detail_bloc.dart';

class CollectingRequestDetailEvent extends AbstractEvent {
  const CollectingRequestDetailEvent();
}

class CollectingRequestDetailInitial extends CollectingRequestDetailEvent {
  CollectingRequestDetailInitial(this.id);
  final String id;
}

class ApproveRequestEvent extends CollectingRequestDetailEvent {}
