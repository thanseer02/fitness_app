import 'package:isar/isar.dart';
import 'package:fitjourney/models/weight_entry.dart';
import 'package:fitjourney/models/workout.dart';
import 'package:fitjourney/models/workout_session.dart';
import 'package:fitjourney/models/daily_nutrition.dart';
import 'package:fitjourney/models/achievement.dart';

class ProgressRepository {
  final Isar _isar;
  ProgressRepository(this._isar);

  Future<List<WeightEntry>> getAllWeightEntries() async {
    return _isar.weightEntrys.where().sortByDate().findAll();
  }

  Future<int> getWorkoutSessionsCount() async {
    return _isar.workoutSessions.count();
  }

  Future<List<DailyNutrition>> getAllDailyNutritions() async {
    return _isar.dailyNutritions.where().findAll();
  }

  Future<List<Workout>> getAllWorkouts() async {
    return _isar.workouts.where().findAll();
  }

  Future<int> getRecentWorkoutSessionsCount(DateTime afterDate) async {
    return _isar.workoutSessions.filter().dateGreaterThan(afterDate).count();
  }

  Future<List<WorkoutSession>> getWorkoutSessionsBetween(DateTime start, DateTime end) async {
    return _isar.workoutSessions.filter().dateBetween(start, end).findAll();
  }

  Future<List<DailyNutrition>> getDailyNutritionsBetween(DateTime start, DateTime end) async {
    return _isar.dailyNutritions.filter().dateBetween(start, end).findAll();
  }

  Future<List<WeightEntry>> getWeightEntriesBetween(DateTime start, DateTime end) async {
    return _isar.weightEntrys.filter().dateBetween(start, end).sortByDate().findAll();
  }

  Future<int> getScheduledWorkoutsCount() async {
    return _isar.workouts.count();
  }

  Future<List<WorkoutSession>> getAllWorkoutSessionsDesc() async {
    return _isar.workoutSessions.where().sortByDateDesc().findAll();
  }

  Future<List<Achievement>> getAllAchievements() async {
    return _isar.achievements.where().findAll();
  }

  Future<int> getWeightEntriesCount() async {
    return _isar.weightEntrys.count();
  }

  Future<List<WorkoutSession>> getAllWorkoutSessions() async {
    return _isar.workoutSessions.where().findAll();
  }

  Future<void> saveAchievements(List<Achievement> achievements) async {
    await _isar.writeTxn(() async {
      await _isar.achievements.putAll(achievements);
    });
  }

  Future<void> saveWeightEntry(WeightEntry entry) async {
    await _isar.writeTxn(() async {
      await _isar.weightEntrys.put(entry);
    });
  }
}
