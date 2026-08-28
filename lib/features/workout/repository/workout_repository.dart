import 'package:isar/isar.dart';
import 'package:fitjourney/models/workout.dart';
import 'package:fitjourney/models/exercise.dart';
import 'package:fitjourney/models/workout_session.dart';
import 'package:fitjourney/models/workout_session.dart';
import 'package:fitjourney/models/workout_override.dart';
import 'package:fitjourney/models/missed_workout.dart';
import 'package:fitjourney/models/muscle_group.dart';

class WorkoutHistoryItem {
  final WorkoutSession session;
  final String workoutName;

  WorkoutHistoryItem({required this.session, required this.workoutName});
}

class WorkoutRepository {
  final Isar _isar;
  WorkoutRepository(this._isar);

  Future<void> seedWorkouts() async {
    final count = await _isar.workouts.count();
    if (count > 0) return; // Already seeded

    // Create default exercises
    final benchPress = Exercise()..name = 'Bench Press'..muscleGroup = MuscleGroup.chest..imagePath = 'assets/exercises/bench_press.webp'..sets = 4..reps = '8-12';
    final inclineDbPress = Exercise()..name = 'Incline DB Press'..muscleGroup = MuscleGroup.chest..imagePath = 'assets/exercises/bench_press.webp'..sets = 3..reps = '10-12';
    final cableFly = Exercise()..name = 'Cable Fly'..muscleGroup = MuscleGroup.chest..imagePath = 'assets/exercises/bench_press.webp'..sets = 3..reps = '12-15';
    final tricepPushdown = Exercise()..name = 'Tricep Pushdown'..muscleGroup = MuscleGroup.triceps..imagePath = 'assets/exercises/bench_press.webp'..sets = 3..reps = '10-12';
    
    final latPulldown = Exercise()..name = 'Lat Pulldown'..muscleGroup = MuscleGroup.back..imagePath = 'assets/exercises/lat_pulldown.webp'..sets = 4..reps = '8-12';
    final barbellRow = Exercise()..name = 'Barbell Row'..muscleGroup = MuscleGroup.back..imagePath = 'assets/exercises/lat_pulldown.webp'..sets = 3..reps = '8-12';
    
    final squat = Exercise()..name = 'Squat'..muscleGroup = MuscleGroup.legs..imagePath = 'assets/exercises/squat.webp'..sets = 4..reps = '6-10';
    final legExtension = Exercise()..name = 'Leg Extension'..muscleGroup = MuscleGroup.legs..imagePath = 'assets/exercises/squat.webp'..sets = 3..reps = '12-15';

    final shoulderPress = Exercise()..name = 'Shoulder Press'..muscleGroup = MuscleGroup.shoulders..imagePath = 'assets/exercises/shoulder_press.webp'..sets = 4..reps = '8-12';

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

  Future<List<Exercise>> getExercisesByMuscleGroups(List<MuscleGroup> groups) async {
    if (groups.isEmpty) return [];
    
    // Isar workaround for OR enum queries
    final allExercises = await _isar.exercises.where().findAll();
    return allExercises.where((e) => groups.contains(e.muscleGroup)).toList();
  }

  Future<int> createAdHocWorkout(List<MuscleGroup> groups, List<Exercise> exercises) async {
    final name = groups.map((g) => g.displayName).join(' + ');
    
    final workout = Workout()
      ..day = 'Custom'
      ..name = name;

    await _isar.writeTxn(() async {
      await _isar.workouts.put(workout);
      workout.exercises.addAll(exercises);
      await workout.exercises.save();
    });
    
    return workout.id;
  }

  Future<List<Workout>> getAllWorkouts() async {
    final workouts = await _isar.workouts.where().findAll();
    for (var w in workouts) {
      await w.exercises.load();
    }
    return workouts;
  }

  Future<List<WorkoutHistoryItem>> getWorkoutHistory() async {
    final sessions = await _isar.workoutSessions.where().sortByDateDesc().findAll();
    final workouts = await _isar.workouts.where().findAll();
    final workoutMap = {for (var w in workouts) w.id: w};

    return sessions.map((s) => WorkoutHistoryItem(
      session: s,
      workoutName: workoutMap[s.workoutId]?.name ?? 'Unknown Workout',
    )).toList();
  }

  Future<List<MissedWorkout>> getMissedWorkouts() async {
    final now = DateTime.now();
    final todayMidnight = DateTime(now.year, now.month, now.day);
    
    final workouts = await _isar.workouts.where().findAll();
    final workoutMap = {for (var w in workouts) w.id: w};
    
    final defaultDays = {
      1: 'Monday', 2: 'Tuesday', 3: 'Wednesday', 
      4: 'Thursday', 5: 'Friday', 6: 'Saturday', 7: 'Sunday'
    };
    
    List<MissedWorkout> missed = [];
    
    for (int i = 1; i <= 7; i++) {
      final date = todayMidnight.subtract(Duration(days: i));
      
      // Check for override
      final override = await getWorkoutOverride(date);
      int? expectedWorkoutId;
      
      if (override != null) {
        expectedWorkoutId = override.workoutId; // Can be null (Rest)
      } else {
        // Default schedule
        final dayName = defaultDays[date.weekday];
        final defaultWorkout = workouts.where((w) => w.day == dayName).firstOrNull;
        expectedWorkoutId = defaultWorkout?.id;
      }
      
      if (expectedWorkoutId != null) {
        // Check if session exists
        final hasSession = await _isar.workoutSessions
          .filter()
          .dateEqualTo(date)
          .and()
          .workoutIdEqualTo(expectedWorkoutId)
          .count() > 0;
          
        if (!hasSession) {
          missed.add(MissedWorkout(
            date: date, 
            workoutId: expectedWorkoutId, 
            workoutName: workoutMap[expectedWorkoutId]?.name ?? 'Unknown Workout'
          ));
        }
      }
    }
    
    return missed;
  }

  Future<WorkoutSession?> getSessionDetail(int sessionId) async {
    return await _isar.workoutSessions.get(sessionId);
  }
}
