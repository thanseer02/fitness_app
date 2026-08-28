import 'package:isar/isar.dart';

part 'notification_settings.g.dart';

@collection
class NotificationSettings {
  Id id = 1; // Singleton

  late bool workoutReminderEnabled;
  late String workoutReminderTime; // "HH:MM"

  late bool weighInReminderEnabled;
  late String weighInReminderTime;

  late bool proteinReminderEnabled;
  late String proteinReminderTime;

  NotificationSettings({
    this.workoutReminderEnabled = true,
    this.workoutReminderTime = '08:00',
    this.weighInReminderEnabled = true,
    this.weighInReminderTime = '09:00',
    this.proteinReminderEnabled = true,
    this.proteinReminderTime = '20:00',
  });
}
