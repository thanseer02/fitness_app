import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fitjourney/features/profile/viewmodel/profile_viewmodel.dart';
import 'package:fitjourney/features/profile/view/notification_settings_screen.dart';
import 'package:fitjourney/core/theme/app_colors.dart';
import 'package:fitjourney/core/theme/app_constants.dart';
import 'package:fitjourney/shared/widgets/app_card.dart';
import 'package:fitjourney/shared/widgets/stat_chip.dart';
import 'package:fitjourney/shared/widgets/section_header.dart';
import 'package:fitjourney/features/progress/viewmodel/progress_viewmodel.dart';
import 'package:fitjourney/features/progress/view/widgets/achievements_list.dart';

class ProfileTab extends StatelessWidget {
  const ProfileTab({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ProfileViewModel>();
    final progressViewModel = context.watch<ProgressViewModel>(); // For achievements
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: Builder(
        builder: (context) {
          if (viewModel.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (viewModel.error != null) {
            return Center(child: Text('Error: ${viewModel.error}'));
          }
          final profile = viewModel.userProfile;
          if (profile == null) {
            return const Center(child: Text('No profile found.'));
          }

          return SingleChildScrollView(
            padding: EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header (Avatar, Name, Goal Badge)
                Column(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: theme.colorScheme.surfaceContainerHighest,
                      child: Icon(Icons.person, size: 60, color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.5)),
                    ),
                    SizedBox(height: AppSpacing.md),
                    Text(profile.name, style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold)),
                    SizedBox(height: AppSpacing.xs),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.secondary.withValues(alpha: 0.2),
                        borderRadius: AppRadius.roundRadius,
                      ),
                      child: Text(
                        profile.goal.name.toUpperCase(),
                        style: theme.textTheme.labelMedium?.copyWith(color: AppColors.secondary, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: AppSpacing.xl),

                // Stat Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    StatChip(label: '${profile.age}y'),
                    StatChip(label: '${profile.height.toStringAsFixed(0)}cm'),
                    StatChip(label: '${profile.currentWeight.toStringAsFixed(1)}kg'),
                    StatChip(label: '🎯 ${profile.targetWeight.toStringAsFixed(1)}kg'),
                  ],
                ),
                SizedBox(height: AppSpacing.xl),

                // Achievements Section
                const SectionHeader(title: 'Achievements'),
                SizedBox(height: AppSpacing.sm),
                if (progressViewModel.achievements.isNotEmpty)
                  AchievementsList(achievements: progressViewModel.achievements)
                else
                  AppCard(
                    padding: EdgeInsets.all(AppSpacing.lg),
                    child: Center(
                      child: Text(
                        'No achievements unlocked yet.',
                        style: theme.textTheme.labelMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                      ),
                    ),
                  ),
                SizedBox(height: AppSpacing.xl),

                // Settings List
                const SectionHeader(title: 'Settings'),
                SizedBox(height: AppSpacing.sm),
                AppCard(
                  padding: EdgeInsets.zero,
                  child: Column(
                    children: [
                      _buildSettingsTile(
                        context,
                        icon: Icons.notifications_none,
                        title: 'Notification Settings',
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (_) => const NotificationSettingsScreen()),
                          );
                        },
                      ),
                      const Divider(height: 1),
                      _buildSettingsTile(
                        context,
                        icon: Icons.edit_outlined,
                        title: 'Edit Profile',
                        onTap: () {},
                      ),
                      const Divider(height: 1),
                      _buildSettingsTile(
                        context,
                        icon: Icons.dark_mode_outlined,
                        title: 'Dark Mode',
                        trailing: Switch(
                          value: true, // Example state
                          onChanged: (val) {},
                          activeThumbColor: AppColors.primary,
                        ),
                        onTap: () {},
                      ),
                      const Divider(height: 1),
                      _buildSettingsTile(
                        context,
                        icon: Icons.info_outline,
                        title: 'About FitJourney',
                        onTap: () {},
                      ),
                    ],
                  ),
                ),
                SizedBox(height: AppSpacing.xl),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSettingsTile(BuildContext context, {required IconData icon, required String title, Widget? trailing, VoidCallback? onTap}) {
    final theme = Theme.of(context);
    return ListTile(
      leading: Icon(icon, color: theme.colorScheme.primary),
      title: Text(title, style: theme.textTheme.titleMedium),
      trailing: trailing ?? Icon(Icons.chevron_right, color: theme.colorScheme.onSurfaceVariant),
      onTap: onTap,
    );
  }
}
