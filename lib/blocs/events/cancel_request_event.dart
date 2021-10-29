part of '../cancel_request_bloc.dart';

abstract class CancelRequestEvent extends AbstractEvent {
  const CancelRequestEvent();
}

class CancelReasonChanged extends CancelRequestEvent {
  const CancelReasonChanged(this.cancelReason);

  final String cancelReason;

  @override
  List<String> get props => [cancelReason];
}

class CancelRequestSubmmited extends CancelRequestEvent {}

class CancelRequestIntial extends CancelRequestEvent {}
