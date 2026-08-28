import 'package:flutter/material.dart';
import 'package:fitjourney/models/weight_entry.dart';
import 'package:fitjourney/models/achievement.dart';
import 'package:fitjourney/features/progress/repository/progress_repository.dart';

class ProgressStats {
  final int totalWorkouts;
  final double avgDailyCalories;
  final double avgDailyProtein;
  final double workoutConsistencyPercentage;

  ProgressStats({
    required this.totalWorkouts,
    required this.avgDailyCalories,
    required this.avgDailyProtein,
    required this.workoutConsistencyPercentage,
  });
}

class MonthlySummary {
  final int workoutsCompleted;
  final double totalCalories;
  final double totalProtein;
  final double weightChange;
  final double consistencyPercentage;

  MonthlySummary({
    required this.workoutsCompleted,
    required this.totalCalories,
    required this.totalProtein,
    required this.weightChange,
    required this.consistencyPercentage,
  });
}

class StreakData {
  final int currentStreak;
  final int longestStreak;

  StreakData({required this.currentStreak, required this.longestStreak});
}

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

class ProgressViewModel extends ChangeNotifier {
  final ProgressRepository _repository;

  ProgressViewModel(this._repository) {
    _init();
  }

  bool _isLoading = true;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  List<WeightEntry> _weightHistory = [];
  List<WeightEntry> get weightHistory => _weightHistory;

  ProgressStats? _stats;
  ProgressStats? get stats => _stats;

  MonthlySummary? _monthlySummary;
  MonthlySummary? get monthlySummary => _monthlySummary;

  StreakData? _streakData;
  StreakData? get streakData => _streakData;

  List<AchievementItem> _achievements = [];
  List<AchievementItem> get achievements => _achievements;

  Future<void> _init() async {
    await loadAllProgressData();
  }

  Future<void> loadAllProgressData() async {
    _isLoading = true;
    notifyListeners();
    try {
      _weightHistory = await _repository.getAllWeightEntries();
      _stats = await _calculateStats(_repository);
      _monthlySummary = await _calculateMonthlySummary(_repository);
      _streakData = await _calculateStreak(_repository);
      _achievements = await _fetchAchievements(_repository);
      
      await _evaluateAchievements(_repository);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logWeight(double weight) async {
    _isLoading = true;
    notifyListeners();
    try {
      final entry = WeightEntry()
        ..date = DateTime.now()
        ..weight = weight;
      await _repository.saveWeightEntry(entry);
      
      await loadAllProgressData(); // Reload everything
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<ProgressStats> _calculateStats(ProgressRepository repository) async {
    final totalWorkouts = await repository.getWorkoutSessionsCount();
    final allNutrition = await repository.getAllDailyNutritions();
    double totalCalories = 0;
    double totalProtein = 0;
    for (final daily in allNutrition) {
      for (final meal in daily.meals) {
        for (final entry in meal.entries) {
          totalCalories += entry.calories ?? 0;
          totalProtein += entry.protein ?? 0;
        }
      }
    }
    final avgCalories = allNutrition.isNotEmpty ? (totalCalories / allNutrition.length) : 0.0;
    final avgProtein = allNutrition.isNotEmpty ? (totalProtein / allNutrition.length) : 0.0;
    final thirtyDaysAgo = DateTime.now().subtract(const Duration(days: 30));
    final workouts = await repository.getAllWorkouts();
    final scheduledDaysOfWeek = workouts.map((w) {
      switch (w.day.toLowerCase()) {
        case 'monday': return DateTime.monday;
        case 'tuesday': return DateTime.tuesday;
        case 'wednesday': return DateTime.wednesday;
        case 'thursday': return DateTime.thursday;
        case 'friday': return DateTime.friday;
        case 'saturday': return DateTime.saturday;
        case 'sunday': return DateTime.sunday;
        default: return -1;
      }
    }).where((d) => d != -1).toSet();
    int scheduledDaysInLast30 = 0;
    if (scheduledDaysOfWeek.isNotEmpty) {
      for (int i = 0; i < 30; i++) {
        final date = DateTime.now().subtract(Duration(days: i));
        if (scheduledDaysOfWeek.contains(date.weekday)) {
          scheduledDaysInLast30++;
        }
      }
    }
    final recentSessions = await repository.getRecentWorkoutSessionsCount(thirtyDaysAgo);
    double consistency = 0;
    if (scheduledDaysInLast30 > 0) {
      consistency = (recentSessions / scheduledDaysInLast30) * 100;
    }
    consistency = consistency.clamp(0.0, 100.0);
    return ProgressStats(
      totalWorkouts: totalWorkouts,
      avgDailyCalories: avgCalories,
      avgDailyProtein: avgProtein,
      workoutConsistencyPercentage: consistency,
    );
  }

  Future<MonthlySummary> _calculateMonthlySummary(ProgressRepository repository) async {
    final now = DateTime.now();
    final startOfMonth = DateTime(now.year, now.month, 1);
    final endOfMonth = DateTime(now.year, now.month + 1, 0, 23, 59, 59);
    final workouts = await repository.getWorkoutSessionsBetween(startOfMonth, endOfMonth);
    final workoutsCompleted = workouts.length;
    final nutritions = await repository.getDailyNutritionsBetween(startOfMonth, endOfMonth);
    double totalCals = 0;
    double totalPro = 0;
    for (final n in nutritions) {
      for (final m in n.meals) {
        for (final e in m.entries) {
          totalCals += e.calories ?? 0;
          totalPro += e.protein ?? 0;
        }
      }
    }
    final weights = await repository.getWeightEntriesBetween(startOfMonth, endOfMonth);
    double weightChange = 0;
    if (weights.length >= 2) {
      weightChange = weights.last.weight - weights.first.weight;
    }
    final scheduledWorkoutsCount = await repository.getScheduledWorkoutsCount();
    final weeksInMonth = endOfMonth.day / 7;
    final expectedWorkouts = scheduledWorkoutsCount * weeksInMonth;
    double consistency = 0;
    if (expectedWorkouts > 0) {
      consistency = (workoutsCompleted / expectedWorkouts) * 100;
    }
    consistency = consistency.clamp(0.0, 100.0);
    return MonthlySummary(
      workoutsCompleted: workoutsCompleted,
      totalCalories: totalCals,
      totalProtein: totalPro,
      weightChange: weightChange,
      consistencyPercentage: consistency,
    );
  }

  Future<StreakData> _calculateStreak(ProgressRepository repository) async {
    final sessions = await repository.getAllWorkoutSessionsDesc();
    if (sessions.isEmpty) return StreakData(currentStreak: 0, longestStreak: 0);
    final uniqueDays = sessions.map((s) => DateTime(s.date.year, s.date.month, s.date.day)).toSet().toList();
    uniqueDays.sort((a, b) => b.compareTo(a));
    int currentStreak = 0;
    int longestStreak = 0;
    int tempStreak = 0;
    DateTime? prevDate;
    final today = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    final yesterday = today.subtract(const Duration(days: 1));
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
  }

  Future<List<AchievementItem>> _fetchAchievements(ProgressRepository repository) async {
    final unlocked = await repository.getAllAchievements();
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

  Future<void> _evaluateAchievements(ProgressRepository repository) async {
    final unlockedKeys = _achievements.where((a) => a.isUnlocked).map((a) => a.key).toSet();
    final newUnlocks = <Achievement>[];
    if (!unlockedKeys.contains('first_workout')) {
      if (_stats != null && _stats!.totalWorkouts > 0) {
        newUnlocks.add(Achievement()..key = 'first_workout'..unlockedAt = DateTime.now());
      }
    }
    if (!unlockedKeys.contains('7_day_streak')) {
      if (_streakData != null && _streakData!.longestStreak >= 7) {
        newUnlocks.add(Achievement()..key = '7_day_streak'..unlockedAt = DateTime.now());
      }
    }
    if (!unlockedKeys.contains('100_sets')) {
      final sessions = await repository.getAllWorkoutSessions();
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
    if (!unlockedKeys.contains('4_weigh_ins')) {
      if (await repository.getWeightEntriesCount() >= 4) {
        newUnlocks.add(Achievement()..key = '4_weigh_ins'..unlockedAt = DateTime.now());
      }
    }
    if (newUnlocks.isNotEmpty) {
      await repository.saveAchievements(newUnlocks);
      _achievements = await _fetchAchievements(repository);
    }
  }
}
