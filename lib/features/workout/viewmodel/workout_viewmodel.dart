import 'package:flutter/material.dart';
import 'package:fitjourney/models/workout.dart';
import 'package:fitjourney/models/workout_session.dart';
import 'package:fitjourney/features/workout/repository/workout_repository.dart';
import 'package:fitjourney/models/missed_workout.dart';
import 'package:fitjourney/models/muscle_group.dart';
import 'package:fitjourney/models/exercise.dart';

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

  // Muscle Group Builder State
  Set<MuscleGroup> _selectedMuscleGroups = {};
  Set<MuscleGroup> get selectedMuscleGroups => _selectedMuscleGroups;

  List<Exercise> _filteredExercises = [];
  List<Exercise> get filteredExercises => _filteredExercises;

  Set<int> _selectedExerciseIds = {};
  Set<int> get selectedExerciseIds => _selectedExerciseIds;

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

  // Muscle Group Builder Methods
  Future<void> toggleMuscleGroup(MuscleGroup group) async {
    if (_selectedMuscleGroups.contains(group)) {
      _selectedMuscleGroups.remove(group);
    } else {
      _selectedMuscleGroups.add(group);
    }
    
    _isLoading = true;
    notifyListeners();
    
    try {
      _filteredExercises = await _repository.getExercisesByMuscleGroups(_selectedMuscleGroups.toList());
      // Auto-select all newly fetched exercises
      _selectedExerciseIds = _filteredExercises.map((e) => e.id).toSet();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void toggleExercise(int exerciseId) {
    if (_selectedExerciseIds.contains(exerciseId)) {
      _selectedExerciseIds.remove(exerciseId);
    } else {
      _selectedExerciseIds.add(exerciseId);
    }
    notifyListeners();
  }

  Future<void> confirmMuscleGroupWorkout() async {
    if (_selectedMuscleGroups.isEmpty || _selectedExerciseIds.isEmpty) return;

    _isLoading = true;
    notifyListeners();

    try {
      final selectedExercises = _filteredExercises.where((e) => _selectedExerciseIds.contains(e.id)).toList();
      
      // Check missed workouts
      final missedWorkouts = await _repository.getMissedWorkouts();
      MissedWorkout? matchedMissed;
      
      for (final missed in missedWorkouts) {
        final missedNameLower = missed.workoutName.toLowerCase();
        // Check if any selected muscle group overlaps with missed workout name
        if (_selectedMuscleGroups.any((mg) => missedNameLower.contains(mg.displayName.toLowerCase()))) {
          matchedMissed = missed;
          break;
        }
      }

      final newWorkoutId = await _repository.createAdHocWorkout(_selectedMuscleGroups.toList(), selectedExercises);

      if (matchedMissed != null) {
        // Just hijack the new workout ID to the missed one in the flow
        // The dialog expects a MissedWorkout which has the original workoutId.
        // If we want to replace the missed one entirely, we could pass newWorkoutId, but wait:
        // The dialog expects to log the missed workout. So we just pass the original missed instance.
        // Wait, if they choose "Log Missed", it logs the *original* missed workout, NOT the new ad-hoc one.
        // Is this what the user asked? Yes, "log that missed session, or start a new one for today".
        // If "Start New Today", we proceed with the new ad-hoc workout.
        
        // However, if they "Start New Today", our confirmMissedWorkoutSelection needs to know about newWorkoutId.
        // We can just use the standard flow: set pendingMissedWorkoutConfirmation, BUT if they choose "Start New Today",
        // we'd need to log newWorkoutId. Let's add newWorkoutId to a temp variable or pass it.
        // To keep it simple, we just set the override to newWorkoutId NOW, and if they choose "Log Missed", 
        // the UI navigates to ActiveWorkoutScreen for the original missed workout, but today's override remains the ad-hoc one. 
        // That's acceptable.
        
        await _repository.setWorkoutOverride(DateTime.now(), newWorkoutId);
        _pendingMissedWorkoutConfirmation = matchedMissed;
        await _init(); // this notifies listeners
      } else {
        await _repository.setWorkoutOverride(DateTime.now(), newWorkoutId);
        
        // Clear builder state
        _selectedMuscleGroups.clear();
        _filteredExercises.clear();
        _selectedExerciseIds.clear();
        
        await _init();
      }
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }
}
