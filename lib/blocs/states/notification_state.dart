part of '../notification_bloc.dart';

class NotificationState extends Equatable {
  const NotificationState({
    required this.listNotificationData,
    this.page = 0,
    this.loadStatus = LoadStatus.idle,
    this.refreshStatus = RefreshStatus.idle,
    this.screenStatus = FormzStatus.pure,
    this.unreadCount = 0,
  });

  final List<NotificationData> listNotificationData;
  final int page;
  final LoadStatus loadStatus;
  final RefreshStatus refreshStatus;
  final FormzStatus screenStatus;
  final int unreadCount;

  NotificationState copyWith({
    List<NotificationData>? listNotificationData,
    int? page,
    LoadStatus? loadStatus,
    RefreshStatus? refreshStatus,
    FormzStatus? screenStatus,
    int? unreadCount,
    bool? isChanged,
  }) {
    return NotificationState(
      listNotificationData: listNotificationData ?? this.listNotificationData,
      page: page ?? this.page,
      loadStatus: loadStatus ?? this.loadStatus,
      refreshStatus: refreshStatus ?? this.refreshStatus,
      screenStatus: screenStatus ?? this.screenStatus,
      unreadCount: unreadCount ?? this.unreadCount,
    );
  }

  @override
  List<Object> get props => [
        listNotificationData,
        page,
        loadStatus,
        refreshStatus,
        screenStatus,
        unreadCount,
      ];
}

class NotificationData extends Equatable {
  NotificationData({
    required this.id,
    required this.title,
    required this.body,
    this.screenId,
    this.screenDataId,
    required this.isRead,
    required this.notiType,
    required this.time,
  });

  final String id;
  final String title;
  final String body;
  final int? screenId;
  final String? screenDataId;
  final bool isRead;
  final int notiType;
  final String time;

  NotificationData copyWith({
    String? id,
    String? title,
    String? body,
    int? screenId,
    String? screenDataId,
    bool? isRead,
    int? notiType,
    String? time,
  }) {
    return NotificationData(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      screenId: screenId ?? this.screenId,
      screenDataId: screenDataId ?? this.screenDataId,
      isRead: isRead ?? this.isRead,
      notiType: notiType ?? this.notiType,
      time: time ?? this.time,
    );
  }

  @override
  List<Object?> get props => [
        id,
        title,
        body,
        screenId,
        screenDataId,
        isRead,
        notiType,
        time,
      ];
}
