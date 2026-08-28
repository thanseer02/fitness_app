import 'package:isar/isar.dart';
import 'package:fitjourney/models/workout.dart';
import 'package:fitjourney/models/exercise.dart';
import 'package:fitjourney/models/workout_session.dart';
import 'package:fitjourney/models/workout_override.dart';

class WorkoutRepository {
  final Isar _isar;
  WorkoutRepository(this._isar);

  Future<void> seedWorkouts() async {
    final count = await _isar.workouts.count();
    if (count > 0) return; // Already seeded

    // Create default exercises
    final benchPress = Exercise()..name = 'Bench Press'..muscleGroup = 'Chest'..imagePath = 'assets/exercises/bench_press.webp'..sets = 4..reps = '8-12';
    final inclineDbPress = Exercise()..name = 'Incline DB Press'..muscleGroup = 'Chest'..imagePath = 'assets/exercises/bench_press.webp'..sets = 3..reps = '10-12';
    final cableFly = Exercise()..name = 'Cable Fly'..muscleGroup = 'Chest'..imagePath = 'assets/exercises/bench_press.webp'..sets = 3..reps = '12-15';
    final tricepPushdown = Exercise()..name = 'Tricep Pushdown'..muscleGroup = 'Triceps'..imagePath = 'assets/exercises/bench_press.webp'..sets = 3..reps = '10-12';
    
    final latPulldown = Exercise()..name = 'Lat Pulldown'..muscleGroup = 'Back'..imagePath = 'assets/exercises/lat_pulldown.webp'..sets = 4..reps = '8-12';
    final barbellRow = Exercise()..name = 'Barbell Row'..muscleGroup = 'Back'..imagePath = 'assets/exercises/lat_pulldown.webp'..sets = 3..reps = '8-12';
    
    final squat = Exercise()..name = 'Squat'..muscleGroup = 'Legs'..imagePath = 'assets/exercises/squat.webp'..sets = 4..reps = '6-10';
    final legExtension = Exercise()..name = 'Leg Extension'..muscleGroup = 'Legs'..imagePath = 'assets/exercises/squat.webp'..sets = 3..reps = '12-15';

    final shoulderPress = Exercise()..name = 'Shoulder Press'..muscleGroup = 'Shoulders'..imagePath = 'assets/exercises/shoulder_press.webp'..sets = 4..reps = '8-12';

    await _isar.writeTxn(() async {
      await _isar.exercises.putAll([benchPress, inclineDbPress, cableFly, tricepPushdown, latPulldown, barbellRow, squat, legExtension, shoulderPress]);

      final wMon = Workout()..day = 'Monday'..name = 'Chest & Triceps';
      final wTue = Workout()..day = 'Tuesday'..name = 'Back & Biceps';
      final wThu = Workout()..day = 'Thursday'..name = 'Shoulders & Abs';
      final wFri = Workout()..day = 'Friday'..name = 'Legs';
      
      await _isar.workouts.putAll([wMon, wTue, wThu, wFri]);
      
      wMon.exercises.addAll([benchPress, inclineDbPress, cableFly, tricepPushdown]);
      await wMon.exercises.save();

      wTue.exercises.addAll([latPulldown, barbellRow]);
      await wTue.exercises.save();

      wThu.exercises.addAll([shoulderPress]);
      await wThu.exercises.save();
      
      wFri.exercises.addAll([squat, legExtension]);
      await wFri.exercises.save();
    });
  }

  Future<Workout?> getWorkoutByDay(String dayName) async {
    final workout = await _isar.workouts.filter().dayEqualTo(dayName).findFirst();
    if (workout != null) {
      await workout.exercises.load();
    }
    return workout;
  }

  Future<void> saveWorkoutSession(WorkoutSession session) async {
    await _isar.writeTxn(() async {
      await _isar.workoutSessions.put(session);
    });
  }

  Future<WorkoutOverride?> getWorkoutOverride(DateTime date) async {
    final midnight = DateTime(date.year, date.month, date.day);
    return await _isar.workoutOverrides.filter().dateEqualTo(midnight).findFirst();
  }

  Future<void> setWorkoutOverride(DateTime date, int? workoutId) async {
    final midnight = DateTime(date.year, date.month, date.day);
    await _isar.writeTxn(() async {
      var override = await _isar.workoutOverrides.filter().dateEqualTo(midnight).findFirst();
      override ??= WorkoutOverride()..date = midnight;
      override.workoutId = workoutId;
      await _isar.workoutOverrides.put(override);
    });
  }

  Future<List<Workout>> getAllWorkouts() async {
    final workouts = await _isar.workouts.where().findAll();
    for (var w in workouts) {
      await w.exercises.load();
    }
    return workouts;
  }
}
