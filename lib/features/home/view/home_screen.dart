import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fitjourney/features/profile/viewmodel/user_profile_provider.dart';
import 'package:fitjourney/features/workout/view/workout_tab.dart';

import 'package:fitjourney/features/nutrition/view/nutrition_tab.dart';
import 'package:fitjourney/features/nutrition/viewmodel/nutrition_provider.dart';
import 'package:fitjourney/features/progress/view/progress_tab.dart';
import 'package:fitjourney/features/profile/view/notification_settings_screen.dart';
import 'package:fitjourney/features/profile/viewmodel/theme_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final _tabs = const [
    WorkoutTab(),
    NutritionTab(),
    ProgressTab(),
    _ProfileTab(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _tabs[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        onTap: (i) => setState(() => _currentIndex = i),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.fitness_center), label: 'Workout'),
          BottomNavigationBarItem(icon: Icon(Icons.restaurant), label: 'Nutrition'),
          BottomNavigationBarItem(icon: Icon(Icons.trending_up), label: 'Progress'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}

class _ProfileTab extends ConsumerWidget {
  const _ProfileTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileState = ref.watch(userProfileNotifierProvider);
    final targets = ref.watch(macroTargetsProvider);

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
      body: profileState.when(
        data: (profile) {
          if (profile == null) {
            return const Center(child: Text('No profile found.'));
          }
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text('Welcome, ${profile.name}!', style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Age: ${profile.age}'),
                      Text('Height: ${profile.height} cm'),
                      Text('Current Weight: ${profile.currentWeight} kg'),
                      Text('Target Weight: ${profile.targetWeight} kg'),
                      Text('Goal: ${profile.goal.name}'),
                      Text('Activity Level: ${profile.activityLevel.name}'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Daily Targets', style: Theme.of(context).textTheme.titleLarge),
                      const SizedBox(height: 8),
                      Text('Calories: ${targets.calories.toStringAsFixed(0)} kcal'),
                      Text('Protein: ${targets.protein.toStringAsFixed(0)} g'),
                      Text('Carbs: ${targets.carbs.toStringAsFixed(0)} g'),
                      Text('Fat: ${targets.fat.toStringAsFixed(0)} g'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('App Settings', style: Theme.of(context).textTheme.titleLarge),
                      const SizedBox(height: 8),
                      Consumer(
                        builder: (context, ref, child) {
                          final themeState = ref.watch(themeProvider);
                          final isDark = themeState.value == ThemeMode.dark;
                          return SwitchListTile(
                            contentPadding: EdgeInsets.zero,
                            title: const Text('Dark Mode'),
                            value: isDark,
                            onChanged: (val) {
                              ref.read(themeProvider.notifier).toggleTheme(val);
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text('Error: $e')),
      ),
    );
  }
}

