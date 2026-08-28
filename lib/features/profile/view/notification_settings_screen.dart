import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fitjourney/features/profile/viewmodel/profile_viewmodel.dart';

class NotificationSettingsScreen extends ConsumerWidget {
  const NotificationSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(profileViewModelProvider);

    if (viewModel.isLoading) {
      return const Scaffold(
        appBar: AppBar(title: Text('Notification Settings')),
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
        appBar: AppBar(title: Text('Notification Settings')),
        body: Center(child: Text('No settings available')),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Notification Settings')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSettingTile(
            context,
            ref,
            title: 'Daily Workout Reminder',
            isEnabled: settings.workoutReminderEnabled,
            timeString: settings.workoutReminderTime,
            onToggle: (val) {
              settings.workoutReminderEnabled = val;
              ref.read(profileViewModelProvider).updateNotificationSettings(settings);
            },
            onTimeSelect: (time) {
              settings.workoutReminderTime = '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
              ref.read(profileViewModelProvider).updateNotificationSettings(settings);
            },
          ),
          const Divider(),
          _buildSettingTile(
            context,
            ref,
            title: 'Sunday Weigh-in Reminder',
            isEnabled: settings.weighInReminderEnabled,
            timeString: settings.weighInReminderTime,
            onToggle: (val) {
              settings.weighInReminderEnabled = val;
              ref.read(profileViewModelProvider).updateNotificationSettings(settings);
            },
            onTimeSelect: (time) {
              settings.weighInReminderTime = '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
              ref.read(profileViewModelProvider).updateNotificationSettings(settings);
            },
          ),
          const Divider(),
          _buildSettingTile(
            context,
            ref,
            title: 'Daily Protein Target Reminder',
            isEnabled: settings.proteinReminderEnabled,
            timeString: settings.proteinReminderTime,
            subtitle: 'Cancels if you hit your target for the day',
            onToggle: (val) {
              settings.proteinReminderEnabled = val;
              ref.read(profileViewModelProvider).updateNotificationSettings(settings);
            },
            onTimeSelect: (time) {
              settings.proteinReminderTime = '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
              ref.read(profileViewModelProvider).updateNotificationSettings(settings);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSettingTile(
    BuildContext context, 
    WidgetRef ref, {
    required String title,
    required bool isEnabled,
    required String timeString,
    String? subtitle,
    required ValueChanged<bool> onToggle,
    required ValueChanged<TimeOfDay> onTimeSelect,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SwitchListTile(
          title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          subtitle: subtitle != null ? Text(subtitle) : null,
          value: isEnabled,
          onChanged: onToggle,
          activeThumbColor: Theme.of(context).primaryColor,
        ),
        if (isEnabled)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Reminder Time:', style: TextStyle(fontSize: 16)),
                OutlinedButton.icon(
                  onPressed: () async {
                    final parts = timeString.split(':');
                    final initialTime = TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
                    final selected = await showTimePicker(
                      context: context,
                      initialTime: initialTime,
                    );
                    if (selected != null) {
                      onTimeSelect(selected);
                    }
                  },
                  icon: const Icon(Icons.access_time),
                  label: Text(timeString),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
