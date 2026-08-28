import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import '../models/workout.dart';
import '../models/exercise.dart';
import 'isar_provider.dart';

class WorkoutSeedService {
  static Future<void> seedWorkouts(Isar isar) async {
    final count = await isar.workouts.count();
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

    await isar.writeTxn(() async {
      await isar.exercises.putAll([benchPress, inclineDbPress, cableFly, tricepPushdown, latPulldown, barbellRow, squat, legExtension, shoulderPress]);

      final wMon = Workout()..day = 'Monday'..name = 'Chest & Triceps';
      final wTue = Workout()..day = 'Tuesday'..name = 'Back & Biceps';
      final wThu = Workout()..day = 'Thursday'..name = 'Shoulders & Abs';
      final wFri = Workout()..day = 'Friday'..name = 'Legs';
      
      await isar.workouts.putAll([wMon, wTue, wThu, wFri]);
      
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
}

final todaysWorkoutProvider = FutureProvider<Workout?>((ref) async {
  final isar = await ref.watch(isarProvider.future);
  await WorkoutSeedService.seedWorkouts(isar);

  final today = DateTime.now().weekday; // 1=Mon, 2=Tue...
  const days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
  final dayName = days[today - 1];

  final workout = await isar.workouts.filter().dayEqualTo(dayName).findFirst();
  if (workout != null) {
    await workout.exercises.load();
  }
  return workout;
});
