part of '../notification_bloc.dart';

class NotificationEvent extends AbstractEvent {
  const NotificationEvent();
}

class NotificationInitial extends NotificationEvent {}

class NotificationRefresh extends NotificationEvent {}

class NotificationLoading extends NotificationEvent {}

class NotificationUncountGet extends NotificationEvent {}

class NotificationGetFirst extends NotificationEvent {}

class NotificationRead extends NotificationEvent {
  final String id;
  final int index;

  const NotificationRead(this.id, this.index);
}
