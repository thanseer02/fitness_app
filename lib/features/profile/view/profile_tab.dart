import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fitjourney/features/profile/viewmodel/profile_viewmodel.dart';
import 'package:fitjourney/features/nutrition/viewmodel/nutrition_viewmodel.dart';
import 'package:fitjourney/features/profile/view/notification_settings_screen.dart';

import 'widgets/profile_summary_card.dart';
import 'widgets/daily_targets_card.dart';
import 'widgets/app_settings_card.dart';

class ProfileTab extends ConsumerWidget {
  const ProfileTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(profileViewModelProvider);
    final nutritionViewModel = ref.watch(nutritionViewModelProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const NotificationSettingsScreen()),
              );
            },
          ),
        ],
      ),
      body: Builder(
        builder: (context) {
          if (viewModel.isLoading || nutritionViewModel.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (viewModel.error != null) {
            return Center(child: Text('Error: ${viewModel.error}'));
          }
          final profile = viewModel.userProfile;
          if (profile == null) {
            return const Center(child: Text('No profile found.'));
          }
          final targets = nutritionViewModel.targets;

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text('Welcome, ${profile.name}!', style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: 16),
              ProfileSummaryCard(profile: profile),
              const SizedBox(height: 16),
              DailyTargetsCard(targets: targets),
              const SizedBox(height: 16),
              const AppSettingsCard(),
            ],
          );
        },
      ),
    );
  }
}
