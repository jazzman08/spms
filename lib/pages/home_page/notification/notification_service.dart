import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  late final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin;

  // Constructor initializes the plugin
  NotificationService() {
    _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  }

  // Initialization method for the notification plugin
  Future<void> initialize() async {
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings settings =
        InitializationSettings(android: androidSettings);

    final bool? initialized =
        await _flutterLocalNotificationsPlugin.initialize(settings);

    if (!initialized!) {
      throw Exception('Failed to initialize notifications');
    }
  }

  // Show notification method
  Future<void> showNotification({
    required int id,
    required String title,
    required String body,
  }) async {
    // Ensure that initialization is completed before showing a notification
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'channel_id',
      'channel_name',
      channelDescription: 'This channel is for in-app notifications',
      importance: Importance.max,
      priority: Priority.high,
    );

    const NotificationDetails platformDetails =
        NotificationDetails(android: androidDetails);

    await _flutterLocalNotificationsPlugin.show(
      id,
      title,
      body,
      platformDetails,
    );
  }
}
