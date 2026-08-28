import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'dart:io';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    tz.initializeTimeZones();

    const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
    const DarwinInitializationSettings initializationSettingsDarwin = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );
    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
    );

    await _flutterLocalNotificationsPlugin.initialize(settings: initializationSettings);
  }

  Future<void> requestPermissions() async {
    if (Platform.isIOS) {
      await _flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()?.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
    } else if (Platform.isAndroid) {
      await _flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.requestNotificationsPermission();
    }
  }

  Future<void> scheduleDailyWorkoutReminder(int hour, int minute) async {
    await _flutterLocalNotificationsPlugin.cancel(id: 1);
    await _flutterLocalNotificationsPlugin.zonedSchedule(
      id: 1,
      title: 'Workout Time!',
      body: 'Don\'t forget to hit your scheduled workout today.',
      scheduledDate: _nextInstanceOfTime(hour, minute),
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails('workout_channel', 'Workout Reminders', channelDescription: 'Reminders for daily workouts'),
        iOS: DarwinNotificationDetails(),
      ),
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  Future<void> scheduleSundayWeighInReminder(int hour, int minute) async {
    await _flutterLocalNotificationsPlugin.cancel(id: 2);
    await _flutterLocalNotificationsPlugin.zonedSchedule(
      id: 2,
      title: 'Weekly Weigh-in',
      body: 'It\'s time for your Sunday weigh-in. Check-in to track your progress!',
      scheduledDate: _nextInstanceOfDayAndTime(DateTime.sunday, hour, minute),
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails('weigh_in_channel', 'Weigh-in Reminders', channelDescription: 'Weekly weigh-in reminders'),
        iOS: DarwinNotificationDetails(),
      ),
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
    );
  }

  Future<void> scheduleDailyProteinReminder(int hour, int minute) async {
    await _flutterLocalNotificationsPlugin.cancel(id: 3);
    await _flutterLocalNotificationsPlugin.zonedSchedule(
      id: 3,
      title: 'Protein Goal',
      body: 'You are slightly behind on your protein target today. Keep pushing!',
      scheduledDate: _nextInstanceOfTime(hour, minute),
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails('protein_channel', 'Protein Reminders', channelDescription: 'Reminders for daily protein goals'),
        iOS: DarwinNotificationDetails(),
      ),
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  Future<void> cancelWorkoutReminder() async => await _flutterLocalNotificationsPlugin.cancel(id: 1);
  Future<void> cancelWeighInReminder() async => await _flutterLocalNotificationsPlugin.cancel(id: 2);
  Future<void> cancelProteinReminder() async => await _flutterLocalNotificationsPlugin.cancel(id: 3);

  tz.TZDateTime _nextInstanceOfTime(int hour, int minute) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate = tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }

  tz.TZDateTime _nextInstanceOfDayAndTime(int day, int hour, int minute) {
    tz.TZDateTime scheduledDate = _nextInstanceOfTime(hour, minute);
    while (scheduledDate.weekday != day) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }
}
