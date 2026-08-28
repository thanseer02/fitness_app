import 'package:flutter/material.dart';
import 'package:fitjourney/models/exercise.dart';
import 'package:fitjourney/features/workout/view/active_workout_screen.dart' show SetData;
import 'package:fitjourney/core/theme/app_colors.dart';
import 'package:fitjourney/core/theme/app_constants.dart';
import 'package:fitjourney/shared/widgets/app_button.dart';
import 'package:fitjourney/shared/widgets/progress_ring.dart';
import 'dart:io';
import 'dart:async';

class ExerciseDetailSheet extends StatefulWidget {
  final Exercise exercise;
  final List<SetData> sets;
  final VoidCallback onStateChanged;

  const ExerciseDetailSheet({
    super.key,
    required this.exercise,
    required this.sets,
    required this.onStateChanged,
  });

  @override
  State<ExerciseDetailSheet> createState() => _ExerciseDetailSheetState();
}

class _ExerciseDetailSheetState extends State<ExerciseDetailSheet> {
  Timer? _timer;
  int _restSecondsRemaining = 0;
  final int _defaultRestTime = 60; // 60 seconds

  void _startRestTimer() {
    setState(() {
      _restSecondsRemaining = _defaultRestTime;
    });
    
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_restSecondsRemaining > 0) {
        setState(() {
          _restSecondsRemaining--;
        });
      } else {
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _toggleSet(int index) {
    setState(() {
      widget.sets[index].isCompleted = !widget.sets[index].isCompleted;
    });
    
    widget.onStateChanged();

    // Start rest timer if checking a set as complete (and not the last set)
    if (widget.sets[index].isCompleted && index < widget.sets.length - 1) {
      _startRestTimer();
    } else {
      _timer?.cancel();
      setState(() => _restSecondsRemaining = 0);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
      ),
      padding: EdgeInsets.all(AppSpacing.lg),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag handle
          Container(
            width: 40,
            height: 4,
            margin: EdgeInsets.only(bottom: AppSpacing.lg),
            decoration: BoxDecoration(
              color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
              borderRadius: AppRadius.roundRadius,
            ),
          ),
          
          // Hero Image and Title
          Row(
            children: [
              ClipRRect(
                borderRadius: AppRadius.mdRadius,
                child: Image.file(
                  File(widget.exercise.imagePath),
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                  errorBuilder: (_, _, _) => Container(
                    width: 100,
                    height: 100,
                    color: theme.colorScheme.surfaceContainerHighest,
                    child: const Icon(Icons.fitness_center, size: 40),
                  ),
                ),
              ),
              SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.exercise.name,
                      style: theme.textTheme.headlineSmall,
                    ),
                    SizedBox(height: AppSpacing.xs),
                    Text(
                      '${widget.exercise.sets} sets × ${widget.exercise.reps} reps',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: AppSpacing.xl),
          
          // Rest Timer Section
          if (_restSecondsRemaining > 0) ...[
            Center(
              child: ProgressRing(
                progress: _restSecondsRemaining / _defaultRestTime,
                size: 80,
                strokeWidth: 6,
                color: AppColors.secondary,
                centerWidget: Text(
                  '$_restSecondsRemaining',
                  style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
              ),
            ),
            SizedBox(height: AppSpacing.xl),
          ],
          
          // Sets List
          Flexible(
            child: ListView.separated(
              shrinkWrap: true,
              itemCount: widget.sets.length,
              separatorBuilder: (context, index) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final set = widget.sets[index];
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: AppSpacing.sm),
                  child: Row(
                    children: [
                      Container(
                        width: 32,
                        alignment: Alignment.center,
                        child: Text('${index + 1}', style: theme.textTheme.titleMedium),
                      ),
                      SizedBox(width: AppSpacing.md),
                      
                      // Weight Input
                      Expanded(
                        child: _buildInputCard(
                          theme,
                          'kg',
                          set.weight.toStringAsFixed(1).replaceAll('.0', ''),
                          (val) {
                            if (val.isNotEmpty) set.weight = double.tryParse(val) ?? set.weight;
                          },
                        ),
                      ),
                      SizedBox(width: AppSpacing.md),
                      
                      // Reps Input
                      Expanded(
                        child: _buildInputCard(
                          theme,
                          'reps',
                          set.reps.toString(),
                          (val) {
                            if (val.isNotEmpty) set.reps = int.tryParse(val) ?? set.reps;
                          },
                        ),
                      ),
                      SizedBox(width: AppSpacing.md),
                      
                      // Done Checkbox
                      IconButton(
                        onPressed: () => _toggleSet(index),
                        icon: Icon(
                          set.isCompleted ? Icons.check_circle : Icons.circle_outlined,
                          color: set.isCompleted ? AppColors.secondary : theme.colorScheme.onSurfaceVariant,
                          size: 32,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          SizedBox(height: AppSpacing.lg),
          
          SizedBox(
            width: double.infinity,
            child: AppButton(
              label: 'DONE',
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputCard(ThemeData theme, String label, String initialValue, Function(String) onChanged) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.sm),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: AppRadius.smRadius,
      ),
      child: TextFormField(
        initialValue: initialValue,
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        style: theme.textTheme.titleMedium,
        decoration: InputDecoration(
          border: InputBorder.none,
          suffixText: label,
          suffixStyle: theme.textTheme.bodySmall,
        ),
        onChanged: onChanged,
      ),
    );
  }
}
