import 'package:flutter/material.dart';
import 'package:fitjourney/features/workout/repository/workout_repository.dart';
import 'package:fitjourney/core/theme/app_constants.dart';
import 'package:intl/intl.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WorkoutSessionDetailSheet extends StatelessWidget {
  final WorkoutHistoryItem historyItem;

  const WorkoutSessionDetailSheet({super.key, required this.historyItem});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final session = historyItem.session;

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
      ),
      padding: EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40.w,
              height: 4.h,
              margin: EdgeInsets.only(bottom: AppSpacing.lg),
              decoration: BoxDecoration(
                color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
                borderRadius: AppRadius.roundRadius,
              ),
            ),
          ),
          Text(
            historyItem.workoutName,
            style: theme.textTheme.headlineMedium,
          ),
          SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              Icon(Icons.calendar_today, size: 16.spMin, color: theme.colorScheme.primary),
              SizedBox(width: AppSpacing.xs),
              Text(
                DateFormat('EEEE, MMM d, yyyy').format(session.date),
                style: theme.textTheme.bodyMedium,
              ),
              SizedBox(width: AppSpacing.lg),
              Icon(Icons.timer, size: 16.spMin, color: theme.colorScheme.secondary),
              SizedBox(width: AppSpacing.xs),
              Text(
                '${(session.durationInSeconds / 60).round()} min',
                style: theme.textTheme.bodyMedium,
              ),
            ],
          ),
          SizedBox(height: AppSpacing.lg),
          Divider(),
          SizedBox(height: AppSpacing.md),
          Text(
            'Exercises Performed',
            style: theme.textTheme.titleLarge,
          ),
          SizedBox(height: AppSpacing.md),
          Expanded(
            child: ListView.separated(
              itemCount: session.completedSetsReps.length,
              separatorBuilder: (context, index) => SizedBox(height: AppSpacing.sm),
              itemBuilder: (context, index) {
                final log = session.completedSetsReps[index];
                // Assuming format: "ExerciseName: 10, 10, 8"
                final parts = log.split(':');
                final name = parts[0];
                final reps = parts.length > 1 ? parts[1].trim() : '';

                return Container(
                  padding: EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
                    borderRadius: AppRadius.mdRadius,
                    border: Border.all(
                      color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      if (reps.isNotEmpty) ...[
                        SizedBox(height: AppSpacing.xs),
                        Text(
                          'Reps: $reps',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ]
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
