import 'package:collector_app/blocs/events/abstract_event.dart';
import 'package:collector_app/log/logger.dart';
import 'package:collector_app/providers/configs/injection_config.dart';
import 'package:collector_app/providers/services/notification_service.dart';
import 'package:collector_app/utils/common_function.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

part 'states/notification_state.dart';
part 'events/notification_event.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  NotificationBloc({
    NotificationService? notificationService,
  }) : super(const NotificationState(
          listNotificationData: [],
        )) {
    _notificationService =
        notificationService ?? getIt.get<NotificationService>();
  }

  late NotificationService _notificationService;
  final initialAbstractPage = 2;
  final sizeList = 10;
  @override
  Stream<NotificationState> mapEventToState(NotificationEvent event) async* {
    if (event is NotificationInitial) {
      if (state.listNotificationData.isEmpty) {
        add(NotificationGetFirst());
      }
    } else if (event is NotificationRead) {
      try {
        var noti = state.listNotificationData.elementAt(event.index);

        if (!noti.isRead) {
          bool readResult = await futureAppDuration(
            _notificationService.readNotification(event.id),
          );

          if (readResult) {
            add(NotificationUncountGet());

            var listNotificationData = state.listNotificationData;
            listNotificationData[event.index] = noti;
            yield state.copyWith(
              listNotificationData: listNotificationData,
            );
          }
        }
      } catch (e) {
        AppLog.error(e);
      }
    } else if (event is NotificationGetFirst) {
      int pageSize = initialAbstractPage * sizeList;

      try {
        yield state.copyWith(
          screenStatus: FormzStatus.submissionInProgress,
        );

        var listNotificationData = await getListNotification(1, pageSize);

        yield state.copyWith(
          screenStatus: FormzStatus.submissionSuccess,
          listNotificationData: listNotificationData,
          page: listNotificationData.isNotEmpty ? initialAbstractPage : 0,
        );
      } catch (e) {
        AppLog.error(e);
        yield state.copyWith(
          screenStatus: FormzStatus.submissionFailure,
        );
      }
    } else if (event is NotificationRefresh) {
      add(NotificationUncountGet());

      int pageSize = initialAbstractPage * sizeList;

      try {
        yield state.copyWith(
          refreshStatus: RefreshStatus.refreshing,
        );
        var listNotificationData = await getListNotification(1, pageSize);

        yield state.copyWith(
          refreshStatus: RefreshStatus.completed,
          listNotificationData: listNotificationData,
          page: listNotificationData.isNotEmpty ? initialAbstractPage : 0,
        );
      } catch (e) {
        AppLog.error(e);
        yield state.copyWith(
          refreshStatus: RefreshStatus.failed,
        );
      }
    } else if (event is NotificationLoading) {
      try {
        yield state.copyWith(
          loadStatus: LoadStatus.loading,
        );
        var listNotificationData =
            await getListNotification(state.page + 1, sizeList);

        yield state.copyWith(
          loadStatus: LoadStatus.idle,
          listNotificationData: state.listNotificationData
            ..addAll(listNotificationData),
          page: listNotificationData.isNotEmpty ? state.page + 1 : state.page,
        );
      } catch (e) {
        AppLog.error(e);
        yield state.copyWith(
          loadStatus: LoadStatus.idle,
        );
      }
    } else if (event is NotificationUncountGet) {
      try {
        var count = await _notificationService.getUnreadCount();
        yield state.copyWith(
          unreadCount: count,
        );
      } catch (e) {
        AppLog.error(e);
      }
    }
  }

  Future<List<NotificationData>> getListNotification(
      int page, int pageSize) async {
    return await futureAppDuration<List<NotificationData>>(
      _notificationService.getNotification(page, pageSize),
    );
  }
}
