import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:fitjourney/models/weight_entry.dart';
import 'package:fitjourney/models/workout.dart';
import 'package:fitjourney/models/workout_session.dart';
import 'package:fitjourney/models/daily_nutrition.dart';
import 'package:fitjourney/core/di/isar_provider.dart';

final weightHistoryProvider = FutureProvider<List<WeightEntry>>((ref) async {
  final isar = await ref.watch(isarProvider.future);
  return isar.weightEntrys.where().sortByDate().findAll();
});

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

final progressStatsProvider = FutureProvider<ProgressStats>((ref) async {
  final isar = await ref.watch(isarProvider.future);

  // 1. Total Workouts
  final totalWorkouts = await isar.workoutSessions.count();

  // 2. Average Daily Calories & Protein
  final allNutrition = await isar.dailyNutritions.where().findAll();
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

  // 3. Workout Consistency (Last 30 days)
  final thirtyDaysAgo = DateTime.now().subtract(const Duration(days: 30));
  
  // Find scheduled days of week (1=Mon, 7=Sun) from Workouts
  final workouts = await isar.workouts.where().findAll();
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

  final recentSessions = await isar.workoutSessions
      .filter()
      .dateGreaterThan(thirtyDaysAgo)
      .count();

  double consistency = 0;
  if (scheduledDaysInLast30 > 0) {
    consistency = (recentSessions / scheduledDaysInLast30) * 100;
  }
  // Cap at 100% in case they did extra workouts
  consistency = consistency.clamp(0.0, 100.0);

  return ProgressStats(
    totalWorkouts: totalWorkouts,
    avgDailyCalories: avgCalories,
    avgDailyProtein: avgProtein,
    workoutConsistencyPercentage: consistency,
  );
});

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

final monthlySummaryProvider = FutureProvider<MonthlySummary>((ref) async {
  final isar = await ref.watch(isarProvider.future);
  
  final now = DateTime.now();
  final startOfMonth = DateTime(now.year, now.month, 1);
  final endOfMonth = DateTime(now.year, now.month + 1, 0, 23, 59, 59);

  // 1. Workouts this month
  final workouts = await isar.workoutSessions
      .filter()
      .dateBetween(startOfMonth, endOfMonth)
      .findAll();
  final workoutsCompleted = workouts.length;

  // 2. Nutrition this month
  final nutritions = await isar.dailyNutritions
      .filter()
      .dateBetween(startOfMonth, endOfMonth)
      .findAll();
  
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

  // 3. Weight change
  final weights = await isar.weightEntrys
      .filter()
      .dateBetween(startOfMonth, endOfMonth)
      .sortByDate()
      .findAll();
  
  double weightChange = 0;
  if (weights.length >= 2) {
    weightChange = weights.last.weight - weights.first.weight;
  }

  // 4. Consistency
  final scheduledWorkoutsCount = await isar.workouts.count();
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
});

