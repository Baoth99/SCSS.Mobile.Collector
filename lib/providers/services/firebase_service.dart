import 'package:collector_app/blocs/collecting_request_detail_bloc.dart';
import 'package:collector_app/blocs/home_bloc.dart';
import 'package:collector_app/blocs/notification_bloc.dart';
import 'package:collector_app/constants/constants.dart';
import 'package:collector_app/log/logger.dart';
import 'package:collector_app/providers/configs/injection_config.dart';
import 'package:collector_app/providers/services/identity_server_service.dart';
import 'package:collector_app/ui/app.dart';
import 'package:collector_app/ui/layouts/dealer_transaction_detail_layout.dart';
import 'package:collector_app/ui/layouts/pending_request_detail_layout.dart';
import 'package:collector_app/ui/layouts/seller_transaction_detail_layout.dart';
import 'package:collector_app/ui/widgets/function_widgets.dart';
import 'package:collector_app/utils/common_function.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Handling a background message : ${message.messageId}");
  print(message.data);
}

Future<void> _firebaseLocalMessagingHandler() async {
  AndroidNotificationChannel channel = const AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    'This channel is used for important notifications.', // description
    importance: Importance.high,
  );

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);
  // Get icon !
  var intializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/vechaixanh_ic_launcher');
  var initializationSettings =
      InitializationSettings(android: intializationSettingsAndroid);

  flutterLocalNotificationsPlugin.initialize(initializationSettings);

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    RemoteNotification? notification = message.notification;

    AndroidNotification? android = message.notification?.android;
    if (notification != null && android != null) {
      AndroidNotificationDetails notificationDetails =
          AndroidNotificationDetails(
              channel.id, channel.name, channel.description,
              importance: Importance.max,
              playSound: true,
              priority: Priority.high,
              groupKey: channel.groupId);
      NotificationDetails notificationDetailsPlatformSpefics =
          NotificationDetails(android: notificationDetails);
      flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          notificationDetailsPlatformSpefics);
    }
  });
}

class FirebaseNotification {
  FirebaseNotification({IdentityServerService? identityServerService}) {
    _identityServerService =
        identityServerService ?? getIt.get<IdentityServerService>();
  }

  late IdentityServerService _identityServerService;

  initialize() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    await _firebaseLocalMessagingHandler();
    await _firebaseOnRefreshToken(_identityServerService.updateDeviceId);
    // add listner to notification service
    await FirebaseNotification.addMessagingHandler();
  }

  Future<String?> getToken() async {
    String? token = await FirebaseMessaging.instance.getToken();
    return token;
  }

  Future<void> updateToken() async {
    futureAppDuration(getToken().then((deviceID) async {
      if (deviceID != null && deviceID.isNotEmpty) {
        var result = await _identityServerService.updateDeviceId(deviceID);
        AppLog.info('Update token $result');
        if (!result) {
          throw Exception();
        }
      } else {
        throw Exception();
      }
    }).catchError((e) {
      AppLog.error(e);
    }));
  }

  static Future<void> addMessagingHandler() async {
    await firebaseForegroundMessagingHandler();
    await firebaseonMessageOpenedAppHandler();
  }

  static void handleMessage(RemoteMessage message) {
    CollectorApp.navigatorKey.currentContext
        ?.read<NotificationBloc>()
        .add(NotificationUncountGet());
    //get new messagelist
    CollectorApp.navigatorKey.currentContext
        ?.read<NotificationBloc>()
        .add(NotificationGetFirst());

    //solve problem
    AppLog.info(message.data);
    String? screenId = message.data['screen'];
    String? screenDataId = message.data['id'];
    String? type = message.data['noti_type'];

    if (screenId != null && screenDataId != null && type != null) {
      int? screen = int.tryParse(screenId);
      int? notiType = int.tryParse(type);
      if (screen != null && notiType != null) {
        switch (screen) {
          case 1:
          case 2:
            if (notiType == ActivityLayoutConstants.pending) {
              CollectorApp.navigatorKey.currentState?.pushNamedAndRemoveUntil(
                Routes.pendingRequests,
                ModalRoute.withName(Routes.main),
                arguments: PendingRequestDetailArgs(
                    screenDataId, CollectingRequestDetailStatus.pending),
              );
            } else if (notiType == ActivityLayoutConstants.approved) {
              CollectorApp.navigatorKey.currentState?.pushNamed(
                Routes.pendingRequestDetail,
                arguments: PendingRequestDetailArgs(
                    screenDataId, CollectingRequestDetailStatus.approved),
              );
            } else {
              CollectorApp.navigatorKey.currentState?.pushNamed(
                Routes.sellerTransactionDetail,
                arguments: SellerTransctionDetailArgs(
                  screenDataId,
                ),
              );
            }
            break;
          case 3:
            CollectorApp.navigatorKey.currentState?.pushNamed(
              Routes.dealerTransactionDetail,
              arguments: DealerTransctionDetailArgs(
                screenDataId,
              ),
            );
            break;
          case 4:
            CollectorApp.navigatorKey.currentState?.pushNamedAndRemoveUntil(
              Routes.pendingRequests,
              ModalRoute.withName(Routes.main),
              arguments: PendingRequestDetailArgs(
                  screenDataId, CollectingRequestDetailStatus.pending),
            );
            break;
          default:
        }
      }
    }
  }

  static Future<void> firebaseonMessageOpenedAppHandler() async {
    FirebaseMessaging.onMessageOpenedApp.listen(
      handleMessage,
    );
  }

  static Future<void> removeMessagingHandler() async {
    FirebaseMessaging.instance.deleteToken();
  }

  static Future<void> firebaseForegroundMessagingHandler() async {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      //get uncount
      CollectorApp.navigatorKey.currentContext
          ?.read<NotificationBloc>()
          .add(NotificationUncountGet());
      //get new messagelist
      CollectorApp.navigatorKey.currentContext
          ?.read<NotificationBloc>()
          .add(NotificationGetFirst());
    });
  }

  static Future<void> getNotificationAfterTerminated() async {
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    // If the message also contains a data property with a "type" of "chat",
    // navigate to a chat screen
    if (initialMessage != null) {
      handleMessage(initialMessage);
    }
  }
}

Future<void> _firebaseOnRefreshToken(
    Future<bool> Function(String) updateFunction) async {
  FirebaseMessaging.instance.onTokenRefresh.listen((deviceID) async {
    if (deviceID.isNotEmpty) {
      var result = await updateFunction(deviceID).catchError((e) {
        AppLog.error(e);
      });
      AppLog.info('Onrefreshtoken ${result}');
    }
  }).onError((e) {
    AppLog.error(e);
  });
}
