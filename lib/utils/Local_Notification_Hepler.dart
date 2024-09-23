import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotificationHepler {
  LocalNotificationHepler._();
  static final LocalNotificationHepler localNotificationHepler =
      LocalNotificationHepler._();

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> initLocalNotifications() async {
    AndroidInitializationSettings androidInitializationSettings =
        AndroidInitializationSettings("mipmap/ic_launcher");
    DarwinInitializationSettings darwinInitializationSettings =
        DarwinInitializationSettings();

    InitializationSettings initializationSettings = InitializationSettings(
      android: androidInitializationSettings,
      iOS: darwinInitializationSettings,
    );
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> showSimpleNotification(
      {required String title, required String dis}) async {
    await initLocalNotifications();
    AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      "Ajay",
      "Simple Notifications",
      priority: Priority.max,
      importance: Importance.max,
    );
    DarwinNotificationDetails darwinNotificationDetails =
        DarwinNotificationDetails();
    NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
      iOS: darwinNotificationDetails,
    );
    await flutterLocalNotificationsPlugin.show(
        1, title, dis, notificationDetails);
  }
}
