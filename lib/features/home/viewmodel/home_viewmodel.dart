import 'package:flutter/material.dart';
import 'package:fitjourney/features/workout/repository/workout_repository.dart';
import 'package:fitjourney/models/missed_workout.dart';

class HomeViewModel extends ChangeNotifier {
  final WorkoutRepository _workoutRepository;

  HomeViewModel(this._workoutRepository) {
    fetchMissedWorkouts();
  }

  List<MissedWorkout> _missedWorkouts = [];
  List<MissedWorkout> get missedWorkouts => _missedWorkouts;

  bool _isMissedWorkoutsDismissed = false;
  bool get isMissedWorkoutsDismissed => _isMissedWorkoutsDismissed;

  Future<void> fetchMissedWorkouts() async {
    try {
      _missedWorkouts = await _workoutRepository.getMissedWorkouts();
      notifyListeners();
    } catch (e) {
      debugPrint('Error fetching missed workouts: $e');
    }
  }

  void dismissMissedWorkouts() {
    _isMissedWorkoutsDismissed = true;
    notifyListeners();
  }
}
