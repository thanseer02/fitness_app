import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fitjourney/features/profile/viewmodel/profile_viewmodel.dart';
import 'widgets/notification_setting_tile.dart';

class NotificationSettingsScreen extends StatelessWidget {
  const NotificationSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ProfileViewModel>();

    if (viewModel.isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (viewModel.error != null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Notification Settings')),
        body: Center(child: Text('Error: ${viewModel.error}')),
      );
    }

    final settings = viewModel.notificationSettings;
    if (settings == null) {
      return const Scaffold(
        body: Center(child: Text('No settings available')),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Notification Settings')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          NotificationSettingTile(
            title: 'Daily Workout Reminder',
            isEnabled: settings.workoutReminderEnabled,
            timeString: settings.workoutReminderTime,
            onToggle: (val) {
              settings.workoutReminderEnabled = val;
              context.read<ProfileViewModel>().updateNotificationSettings(settings);
            },
            onTimeSelect: (time) {
              settings.workoutReminderTime = '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
              context.read<ProfileViewModel>().updateNotificationSettings(settings);
            },
          ),
          const Divider(),
          NotificationSettingTile(
            title: 'Sunday Weigh-in Reminder',
            isEnabled: settings.weighInReminderEnabled,
            timeString: settings.weighInReminderTime,
            onToggle: (val) {
              settings.weighInReminderEnabled = val;
              context.read<ProfileViewModel>().updateNotificationSettings(settings);
            },
            onTimeSelect: (time) {
              settings.weighInReminderTime = '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
              context.read<ProfileViewModel>().updateNotificationSettings(settings);
            },
          ),
          const Divider(),
          NotificationSettingTile(
            title: 'Daily Protein Target Reminder',
            isEnabled: settings.proteinReminderEnabled,
            timeString: settings.proteinReminderTime,
            subtitle: 'Cancels if you hit your target for the day',
            onToggle: (val) {
              settings.proteinReminderEnabled = val;
              context.read<ProfileViewModel>().updateNotificationSettings(settings);
            },
            onTimeSelect: (time) {
              settings.proteinReminderTime = '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
              context.read<ProfileViewModel>().updateNotificationSettings(settings);
            },
          ),
        ],
      ),
    );
  }
}
