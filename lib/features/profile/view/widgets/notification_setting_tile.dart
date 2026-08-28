import 'package:flutter/material.dart';

class NotificationSettingTile extends StatelessWidget {
  final String title;
  final bool isEnabled;
  final String timeString;
  final String? subtitle;
  final ValueChanged<bool> onToggle;
  final ValueChanged<TimeOfDay> onTimeSelect;

  const NotificationSettingTile({
    super.key,
    required this.title,
    required this.isEnabled,
    required this.timeString,
    this.subtitle,
    required this.onToggle,
    required this.onTimeSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SwitchListTile(
          title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          subtitle: subtitle != null ? Text(subtitle!) : null,
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
