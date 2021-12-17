import 'dart:convert';

import 'package:collector_app/blocs/notification_bloc.dart';
import 'package:collector_app/constants/constants.dart';
import 'package:collector_app/providers/configs/injection_config.dart';
import 'package:collector_app/providers/networks/notification_network.dart';
import 'package:http/http.dart';

abstract class NotificationService {
  Future<List<NotificationData>> getNotification(
    int page,
    int pageSize,
  );

  Future<int> getUnreadCount();

  Future<bool> readNotification(String id);
}

class NotificationServiceImp extends NotificationService {
  NotificationServiceImp({
    NotificationNetwork? notificationNetwork,
  }) {
    _notificationNetwork =
        notificationNetwork ?? getIt.get<NotificationNetwork>();
  }

  late NotificationNetwork _notificationNetwork;

  @override
  Future<List<NotificationData>> getNotification(int page, int pageSize) async {
    Client client = Client();
    List<NotificationData> listNoti = await _notificationNetwork
        .getNotification(
      page,
      pageSize,
      client,
    )
        .then<List<NotificationData>>((responseModel) {
      var data = responseModel.resData;
      if (data != null) {
        var list = data.map((n) {
          String? screenDataId;
          String? screenId;

          if (n.dataCustom.isNotEmpty) {
            var map = jsonDecode(n.dataCustom);
            screenId = map['screen'];
            screenDataId = map['id'];
          }

          return NotificationData(
            id: n.id,
            title: n.title,
            body: n.body,
            isRead: n.isRead,
            notiType: n.notiType,
            time: n.previousTime,
            screenId: screenId != null && screenId.isNotEmpty
                ? int.parse(screenId)
                : null,
            screenDataId: screenDataId,
          );
        }).toList();
        return list;
      } else {
        return [];
      }
    }).whenComplete(() => client.close());

    return listNoti;
  }

  @override
  Future<int> getUnreadCount() async {
    Client client = Client();
    var countResult = await _notificationNetwork
        .getUnreadCount(
          client,
        )
        .then(
          (responseModel) => responseModel.resData,
        )
        .whenComplete(
          () => client.close(),
        );
    return countResult;
  }

  @override
  Future<bool> readNotification(String id) async {
    Client client = Client();
    var result = await _notificationNetwork
        .readNotification(
      id,
      client,
    )
        .then(
      (responseModel) {
        return responseModel.isSuccess &&
            responseModel.statusCode == NetworkConstants.ok200;
      },
    ).whenComplete(
      () => client.close(),
    );
    return result;
  }
}
