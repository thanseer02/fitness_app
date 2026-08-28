import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import '../models/achievement.dart';
import '../models/workout_session.dart';
import '../models/daily_nutrition.dart';
import '../models/weight_entry.dart';
import 'isar_provider.dart';

class StreakData {
  final int currentStreak;
  final int longestStreak;

  StreakData({required this.currentStreak, required this.longestStreak});
}

final streakProvider = FutureProvider<StreakData>((ref) async {
  final isar = await ref.watch(isarProvider.future);
  final sessions = await isar.workoutSessions.where().sortByDateDesc().findAll();

  if (sessions.isEmpty) return StreakData(currentStreak: 0, longestStreak: 0);

  // Group by distinct days to avoid double counting days with 2+ workouts
  final uniqueDays = sessions.map((s) => DateTime(s.date.year, s.date.month, s.date.day)).toSet().toList();
  uniqueDays.sort((a, b) => b.compareTo(a)); // Descending

  int currentStreak = 0;
  int longestStreak = 0;
  int tempStreak = 0;
  DateTime? prevDate;

  final today = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
  final yesterday = today.subtract(const Duration(days: 1));

  // If latest workout isn't today or yesterday, current streak is 0
  if (uniqueDays.first != today && uniqueDays.first != yesterday) {
    currentStreak = 0;
  } else {
    currentStreak = 1;
    for (int i = 0; i < uniqueDays.length - 1; i++) {
      if (uniqueDays[i].difference(uniqueDays[i+1]).inDays == 1) {
        currentStreak++;
      } else {
        break;
      }
    }
  }

  // Calculate longest historical streak
  for (final day in uniqueDays) {
    if (prevDate == null) {
      tempStreak = 1;
    } else {
      if (prevDate.difference(day).inDays == 1) {
        tempStreak++;
      } else {
        if (tempStreak > longestStreak) longestStreak = tempStreak;
        tempStreak = 1;
      }
    }
    prevDate = day;
  }
  if (tempStreak > longestStreak) longestStreak = tempStreak;

  return StreakData(currentStreak: currentStreak, longestStreak: longestStreak);
});

class AchievementItem {
  final String key;
  final String title;
  final String description;
  final String iconPath;
  final bool isUnlocked;

  AchievementItem({
    required this.key,
    required this.title,
    required this.description,
    required this.iconPath,
    required this.isUnlocked,
  });
}

class AchievementNotifier extends AsyncNotifier<List<AchievementItem>> {
  @override
  Future<List<AchievementItem>> build() async {
    return _fetchAchievements();
  }

  Future<List<AchievementItem>> _fetchAchievements() async {
    final isar = await ref.watch(isarProvider.future);
    final unlocked = await isar.achievements.where().findAll();
    final unlockedKeys = unlocked.map((a) => a.key).toSet();

    return [
      AchievementItem(
        key: 'first_workout',
        title: 'First Blood',
        description: 'Complete your first workout.',
        iconPath: 'assets/achievements/first_workout.png',
        isUnlocked: unlockedKeys.contains('first_workout'),
      ),
      AchievementItem(
        key: '7_day_streak',
        title: 'On a Roll',
        description: 'Hit a 7-day workout streak.',
        iconPath: 'assets/achievements/streak.png',
        isUnlocked: unlockedKeys.contains('7_day_streak'),
      ),
      AchievementItem(
        key: '100_sets',
        title: 'Century Club',
        description: 'Complete 100 total sets.',
        iconPath: 'assets/achievements/100_sets.png',
        isUnlocked: unlockedKeys.contains('100_sets'),
      ),
      AchievementItem(
        key: 'protein_10',
        title: 'Protein Junkie',
        description: 'Hit your protein target 10 times.',
        iconPath: 'assets/achievements/protein.png',
        isUnlocked: unlockedKeys.contains('protein_10'),
      ),
      AchievementItem(
        key: '4_weigh_ins',
        title: 'Consistent Tracker',
        description: 'Log 4 weekly weigh-ins.',
        iconPath: 'assets/achievements/weigh_in.png',
        isUnlocked: unlockedKeys.contains('4_weigh_ins'),
      ),
    ];
  }

  Future<void> evaluateAchievements() async {
    final isar = await ref.read(isarProvider.future);
    
    // We fetch currently unlocked to avoid re-unlocking
    final unlocked = await isar.achievements.where().findAll();
    final unlockedKeys = unlocked.map((a) => a.key).toSet();

    final newUnlocks = <Achievement>[];

    // 1. First Workout
    if (!unlockedKeys.contains('first_workout')) {
      if (await isar.workoutSessions.count() > 0) {
        newUnlocks.add(Achievement()..key = 'first_workout'..unlockedAt = DateTime.now());
      }
    }

    // 2. 7 Day Streak
    if (!unlockedKeys.contains('7_day_streak')) {
      final streakData = await ref.read(streakProvider.future);
      if (streakData.longestStreak >= 7) {
        newUnlocks.add(Achievement()..key = '7_day_streak'..unlockedAt = DateTime.now());
      }
    }

    // 3. 100 Sets
    if (!unlockedKeys.contains('100_sets')) {
      final sessions = await isar.workoutSessions.where().findAll();
      int totalSets = 0;
      for (final s in sessions) {
        for (final repString in s.completedSetsReps) {
          final parts = repString.split(':');
          if (parts.length == 2) {
            totalSets += parts[1].split(',').length;
          }
        }
      }
      if (totalSets >= 100) {
        newUnlocks.add(Achievement()..key = '100_sets'..unlockedAt = DateTime.now());
      }
    }

    // 4. 4 Weekly Check-ins
    if (!unlockedKeys.contains('4_weigh_ins')) {
      if (await isar.weightEntrys.count() >= 4) {
        newUnlocks.add(Achievement()..key = '4_weigh_ins'..unlockedAt = DateTime.now());
      }
    }

    if (newUnlocks.isNotEmpty) {
      await isar.writeTxn(() async {
        await isar.achievements.putAll(newUnlocks);
      });
      state = AsyncValue.data(await _fetchAchievements());
    }
  }
}

final achievementProvider = AsyncNotifierProvider<AchievementNotifier, List<AchievementItem>>(() {
  return AchievementNotifier();
});
