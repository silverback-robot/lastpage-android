import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class ShowNotification {
  static final _notification = FlutterLocalNotificationsPlugin();
  static Future<NotificationDetails> _notificationDetails(
      AndroidNotificationChannel channel) async {
    return NotificationDetails(
      android: AndroidNotificationDetails(
        channel.id,
        channel.name,
        channelDescription: channel.description,
        importance: Importance.max,
        priority: Priority.high,
        ticker: 'ticker',
        icon:
            'ic_stat_name', // Name set during Image Asset creation (Type: Notification Icon)
      ),
      iOS: null,
      linux: null,
      macOS: null,
    );
  }

  static Future showNotification({
    int id = 0,
    String? title,
    String? body,
    String? payload,
  }) async {
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
        'high_importance_channel', // id
        'High Importance Notifications', // title
        description:
            'This channel is used for important notifications.', // description
        importance: Importance.high,
        playSound: true);

    await _notification
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
    return _notification.show(
      id,
      title,
      body,
      await _notificationDetails(channel),
      payload: payload,
    );
  }
}
