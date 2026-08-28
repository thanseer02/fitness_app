import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fitjourney/models/workout.dart';
import 'package:fitjourney/models/workout_session.dart';
import 'package:fitjourney/features/workout/repository/workout_repository.dart';

final workoutViewModelProvider = ChangeNotifierProvider<WorkoutViewModel>((ref) {
  return WorkoutViewModel(ref);
});

class WorkoutViewModel extends ChangeNotifier {
  final Ref _ref;
  
  WorkoutViewModel(this._ref) {
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
      final repository = await _ref.read(workoutRepositoryProvider.future);
      await repository.seedWorkouts();
      
      final today = DateTime.now().weekday;
      const days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
      final dayName = days[today - 1];

      _todaysWorkout = await repository.getWorkoutByDay(dayName);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> completeWorkout(WorkoutSession session) async {
    try {
      final repository = await _ref.read(workoutRepositoryProvider.future);
      await repository.saveWorkoutSession(session);
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }
}
