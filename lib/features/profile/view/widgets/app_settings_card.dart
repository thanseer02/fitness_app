import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fitjourney/features/profile/viewmodel/profile_viewmodel.dart';

class AppSettingsCard extends StatelessWidget {
  const AppSettingsCard({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ProfileViewModel>().themeMode == ThemeMode.dark;
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('App Settings', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Dark Mode'),
              value: isDark,
              onChanged: (val) {
                context.read<ProfileViewModel>().toggleTheme(val);
              },
            ),
          ],
        ),
      ),
    );
  }
}
