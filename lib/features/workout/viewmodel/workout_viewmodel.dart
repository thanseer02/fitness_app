import 'package:flutter/material.dart';
import 'package:fitjourney/models/workout.dart';
import 'package:fitjourney/models/workout_session.dart';
import 'package:fitjourney/features/workout/repository/workout_repository.dart';
import 'package:fitjourney/models/missed_workout.dart';

class WorkoutViewModel extends ChangeNotifier {
  final WorkoutRepository _repository;
  
  WorkoutViewModel(this._repository) {
    _init();
  }

  bool _isLoading = true;
  bool get isLoading => _isLoading;

  Workout? _todaysWorkout;
  Workout? get todaysWorkout => _todaysWorkout;

  bool _isCustomWorkout = false;
  bool get isCustomWorkout => _isCustomWorkout;

  List<Workout> _availableWorkouts = [];
  List<Workout> get availableWorkouts => _availableWorkouts;

  String? _error;
  String? get error => _error;

  MissedWorkout? _pendingMissedWorkoutConfirmation;
  MissedWorkout? get pendingMissedWorkoutConfirmation => _pendingMissedWorkoutConfirmation;

  Future<void> _init() async {
    _isLoading = true;
    notifyListeners();
    try {
      await _repository.seedWorkouts();
      _availableWorkouts = await _repository.getAllWorkouts();
      
      final now = DateTime.now();
      final override = await _repository.getWorkoutOverride(now);
      
      if (override != null) {
        _isCustomWorkout = true;
        if (override.workoutId == null) {
          _todaysWorkout = null; // Explicit Rest Day
        } else {
          _todaysWorkout = _availableWorkouts.cast<Workout?>().firstWhere(
            (w) => w?.id == override.workoutId,
            orElse: () => null,
          );
        }
      } else {
        _isCustomWorkout = false;
        final today = now.weekday;
        const days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
        final dayName = days[today - 1];

        _todaysWorkout = await _repository.getWorkoutByDay(dayName);
      }
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

  Future<void> finishActiveWorkout(Workout workout, DateTime startTime, List<String> sessionLogs, {DateTime? overrideDate}) async {
    final duration = DateTime.now().difference(startTime).inSeconds;
    final logDate = overrideDate ?? DateTime.now();

    final session = WorkoutSession()
      ..date = logDate
      ..workoutId = workout.id
      ..completedSetsReps = sessionLogs
      ..durationInSeconds = duration;

    await completeWorkout(session);
  }

  Future<void> selectWorkout(int? newWorkoutId) async {
    _isLoading = true;
    notifyListeners();
    try {
      if (newWorkoutId == null) {
        // Just override to Rest Day
        await _repository.setWorkoutOverride(DateTime.now(), null);
        await _init();
        return;
      }

      final missedWorkouts = await _repository.getMissedWorkouts();
      final match = missedWorkouts.where((m) => m.workoutId == newWorkoutId).firstOrNull;

      if (match != null) {
        _pendingMissedWorkoutConfirmation = match;
        _isLoading = false;
        notifyListeners();
      } else {
        await _repository.setWorkoutOverride(DateTime.now(), newWorkoutId);
        await _init();
      }
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> confirmMissedWorkoutSelection(bool retroactivelyLog) async {
    if (_pendingMissedWorkoutConfirmation == null) return;
    
    final missed = _pendingMissedWorkoutConfirmation!;
    _pendingMissedWorkoutConfirmation = null;
    notifyListeners();

    if (!retroactivelyLog) {
      _isLoading = true;
      notifyListeners();
      try {
        await _repository.setWorkoutOverride(DateTime.now(), missed.workoutId);
        await _init();
      } catch (e) {
        _error = e.toString();
        _isLoading = false;
        notifyListeners();
      }
    }
  }
}
