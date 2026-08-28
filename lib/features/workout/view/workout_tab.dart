import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fitjourney/features/workout/viewmodel/workout_viewmodel.dart';
import 'widgets/workout_overview_view.dart';
import 'package:fitjourney/features/workout/view/workout_history_screen.dart';

import 'package:fitjourney/features/workout/view/widgets/workout_picker_sheet.dart';
import 'package:fitjourney/core/theme/app_constants.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:fitjourney/features/workout/view/active_workout_screen.dart';
import 'package:intl/intl.dart';

class WorkoutTab extends StatefulWidget {
  const WorkoutTab({super.key});

  @override
  State<WorkoutTab> createState() => _WorkoutTabState();
}

class _WorkoutTabState extends State<WorkoutTab> {
  WorkoutViewModel? _viewModel;
  bool _isDialogShowing = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _viewModel = context.read<WorkoutViewModel>();
      _viewModel?.addListener(_onViewModelChanged);
    });
  }

  @override
  void dispose() {
    _viewModel?.removeListener(_onViewModelChanged);
    super.dispose();
  }

  void _onViewModelChanged() {
    if (!mounted) return;
    final missed = _viewModel?.pendingMissedWorkoutConfirmation;
    if (missed != null && !_isDialogShowing) {
      _isDialogShowing = true;
      final dateStr = DateFormat('EEEE, MMM d').format(missed.date);
      
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (dialogContext) => AlertDialog(
          title: const Text('Missed Session'),
          content: Text('You haven\'t completed ${missed.workoutName} from $dateStr yet. Do you want to log that missed session, or start a new one for today?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
                _isDialogShowing = false;
                _viewModel?.confirmMissedWorkoutSelection(false);
              },
              child: const Text('Start New Today'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(dialogContext);
                _isDialogShowing = false;
                _viewModel?.confirmMissedWorkoutSelection(true);
                
                final workoutToLog = _viewModel?.availableWorkouts.firstWhere((w) => w.id == missed.workoutId);
                if (workoutToLog != null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ActiveWorkoutScreen(
                        workout: workoutToLog,
                        overrideDate: missed.date,
                      ),
                    ),
                  );
                }
              },
              child: const Text('Log Missed Session'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<WorkoutViewModel>();
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Text('Today\'s Workout'),
            if (viewModel.isCustomWorkout) ...[
              SizedBox(width: AppSpacing.sm),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                decoration: BoxDecoration(
                  color: theme.colorScheme.tertiaryContainer,
                  borderRadius: AppRadius.smRadius,
                ),
                child: Text(
                  'CUSTOM',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.onTertiaryContainer,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            tooltip: 'Workout History',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const WorkoutHistoryScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.edit_calendar),
            tooltip: 'Change Workout',
            onPressed: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (_) => FractionallySizedBox(
                  heightFactor: 0.8,
                  child: WorkoutPickerSheet(viewModel: viewModel),
                ),
              );
            },
          ),
        ],
      ),
      body: _buildBody(context, viewModel),
    );
  }

  Widget _buildBody(BuildContext context, WorkoutViewModel viewModel) {
    if (viewModel.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (viewModel.error != null) {
      return Center(child: Text('Error loading workout: ${viewModel.error}'));
    }

    final workout = viewModel.todaysWorkout;
    if (workout == null) {
      return const Center(
        child: Text('Rest Day! Enjoy your recovery.', style: TextStyle(fontSize: 18)),
      );
    }

    return WorkoutOverviewView(workout: workout);
  }
}
