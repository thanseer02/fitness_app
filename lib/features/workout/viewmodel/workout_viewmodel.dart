import 'package:flutter/material.dart';
import 'package:fitjourney/models/workout.dart';
import 'package:fitjourney/models/workout_session.dart';
import 'package:fitjourney/features/workout/repository/workout_repository.dart';

class WorkoutViewModel extends ChangeNotifier {
  final WorkoutRepository _repository;
  
  WorkoutViewModel(this._repository) {
    _init();
  }

  bool _isLoading = true;
  bool get isLoading => _isLoading;

  Workout? _todaysWorkout;
  Workout? get todaysWorkout => _todaysWorkout;

  String? _error;
  String? get error => _error;

  Future<void> _init() async {
    _isLoading = true;
    notifyListeners();
    try {
      await _repository.seedWorkouts();
      
      final today = DateTime.now().weekday;
      const days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
      final dayName = days[today - 1];

      _todaysWorkout = await _repository.getWorkoutByDay(dayName);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> completeWorkout(WorkoutSession session) async {
    _isLoading = true;
    notifyListeners();
    try {
      await _repository.saveWorkoutSession(session);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> finishActiveWorkout(Workout workout, DateTime startTime, Map<int, List<bool>> completedSets) async {
    final exercises = workout.exercises.toList();
    final List<String> sessionLogs = [];

    for (int i = 0; i < exercises.length; i++) {
      final ex = exercises[i];
      final completedCount = completedSets[i]!.where((completed) => completed).length;
      if (completedCount > 0) {
        sessionLogs.add('${ex.name}: $completedCount / ${ex.sets} sets');
      }
    }

    final duration = DateTime.now().difference(startTime).inSeconds;

    final session = WorkoutSession()
      ..date = DateTime.now()
      ..workoutId = workout.id
      ..completedSetsReps = sessionLogs
      ..durationInSeconds = duration;

    await completeWorkout(session);
  }
}
