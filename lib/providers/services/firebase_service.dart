import 'package:collector_app/blocs/home_bloc.dart';
import 'package:collector_app/blocs/notification_bloc.dart';
import 'package:collector_app/log/logger.dart';
import 'package:collector_app/providers/configs/injection_config.dart';
import 'package:collector_app/providers/services/identity_server_service.dart';
import 'package:collector_app/ui/app.dart';
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
    // add listner to notification service
    await FirebaseNotification.addMessagingHandler();
    await _firebaseLocalMessagingHandler();
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
    firebaseForegroundMessagingHandler();
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
      //update pending list
      CollectorApp.navigatorKey.currentContext
          ?.read<HomeBloc>()
          .add(HomeInitial());
    });
  }
}
