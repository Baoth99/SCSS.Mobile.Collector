import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

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
  initialize() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    await _firebaseLocalMessagingHandler();
  }

  Future<String?> getToken() async {
    String? token = await FirebaseMessaging.instance.getToken();
    return token;
  }
}
