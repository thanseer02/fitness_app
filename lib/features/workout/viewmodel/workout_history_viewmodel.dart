import 'package:flutter/material.dart';
import 'package:fitjourney/features/workout/repository/workout_repository.dart';
import 'package:fitjourney/models/workout_session.dart';

enum WorkoutHistoryFilter { all, thisWeek, thisMonth }

class WorkoutHistoryViewModel extends ChangeNotifier {
  final WorkoutRepository _repository;

  WorkoutHistoryViewModel(this._repository) {
    fetchHistory();
  }

  bool _isLoading = true;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  List<WorkoutHistoryItem> _allSessions = [];
  List<WorkoutHistoryItem> _filteredSessions = [];
  List<WorkoutHistoryItem> get filteredSessions => _filteredSessions;

  WorkoutHistoryFilter _filter = WorkoutHistoryFilter.all;
  WorkoutHistoryFilter get filter => _filter;

  Future<void> fetchHistory() async {
    _isLoading = true;
    notifyListeners();

    try {
      _allSessions = await _repository.getWorkoutHistory();
      _applyFilter();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void setFilter(WorkoutHistoryFilter newFilter) {
    if (_filter == newFilter) return;
    _filter = newFilter;
    _applyFilter();
    notifyListeners();
  }

  void _applyFilter() {
    final now = DateTime.now();
    switch (_filter) {
      case WorkoutHistoryFilter.all:
        _filteredSessions = List.from(_allSessions);
        break;
      case WorkoutHistoryFilter.thisWeek:
        // A simple week check: within last 7 days
        final weekAgo = now.subtract(const Duration(days: 7));
        _filteredSessions = _allSessions.where((s) => s.session.date.isAfter(weekAgo)).toList();
        break;
      case WorkoutHistoryFilter.thisMonth:
        final monthAgo = DateTime(now.year, now.month - 1, now.day);
        _filteredSessions = _allSessions.where((s) => s.session.date.isAfter(monthAgo)).toList();
        break;
    }
  }
}
