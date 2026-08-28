import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/notification_settings.dart';
import '../services/notification_service.dart';
import 'isar_provider.dart';

class NotificationSettingsNotifier extends AsyncNotifier<NotificationSettings> {
  @override
  Future<NotificationSettings> build() async {
    final isar = await ref.watch(isarProvider.future);
    
    var settings = await isar.notificationSettings.get(1);
    if (settings == null) {
      settings = NotificationSettings(); // Default values
      await isar.writeTxn(() async {
        await isar.notificationSettings.put(settings!);
      });
    }

    _applySettings(settings);
    return settings;
  }

  Future<void> updateSettings(NotificationSettings newSettings) async {
    final isar = await ref.read(isarProvider.future);
    newSettings.id = 1;
    
    await isar.writeTxn(() async {
      await isar.notificationSettings.put(newSettings);
    });

    _applySettings(newSettings);
    state = AsyncValue.data(newSettings);
  }

  void _applySettings(NotificationSettings settings) {
    final service = NotificationService();
    
    if (settings.workoutReminderEnabled) {
      final parts = settings.workoutReminderTime.split(':');
      service.scheduleDailyWorkoutReminder(int.parse(parts[0]), int.parse(parts[1]));
    } else {
      service.cancelWorkoutReminder();
    }

    if (settings.weighInReminderEnabled) {
      final parts = settings.weighInReminderTime.split(':');
      service.scheduleSundayWeighInReminder(int.parse(parts[0]), int.parse(parts[1]));
    } else {
      service.cancelWeighInReminder();
    }

    if (settings.proteinReminderEnabled) {
      final parts = settings.proteinReminderTime.split(':');
      service.scheduleDailyProteinReminder(int.parse(parts[0]), int.parse(parts[1]));
    } else {
      service.cancelProteinReminder();
    }
  }
}

final notificationSettingsProvider = AsyncNotifierProvider<NotificationSettingsNotifier, NotificationSettings>(() {
  return NotificationSettingsNotifier();
});
