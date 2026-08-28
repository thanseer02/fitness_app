import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:fitjourney/models/weight_entry.dart';
import 'package:fitjourney/core/theme/app_colors.dart';
import 'package:fitjourney/core/theme/app_constants.dart';
import 'package:intl/intl.dart';

class WeightTrackerChart extends StatelessWidget {
  final List<WeightEntry> entries;

  const WeightTrackerChart({super.key, required this.entries});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    if (entries.isEmpty) {
      return Center(
        child: Text(
          'No weight data available yet.\nLog your first weight to see progress!',
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
        ),
      );
    }

    final sortedEntries = List<WeightEntry>.from(entries)..sort((a, b) => a.date.compareTo(b.date));
    
    // Convert dates to x values (e.g. days since first entry)
    final firstDate = sortedEntries.first.date;
    final spots = sortedEntries.map((e) {
      final days = e.date.difference(firstDate).inDays.toDouble();
      return FlSpot(days, e.weight);
    }).toList();

    final minX = spots.first.x;
    final maxX = spots.last.x;
    final minY = spots.map((e) => e.y).reduce((a, b) => a < b ? a : b) - 2;
    final maxY = spots.map((e) => e.y).reduce((a, b) => a > b ? a : b) + 2;

    return Padding(
      padding: const EdgeInsets.only(right: AppSpacing.md, top: AppSpacing.sm, bottom: AppSpacing.sm),
      child: LineChart(
        LineChartData(
          minX: minX,
          maxX: maxX == minX ? maxX + 1 : maxX, // Avoid division by zero if only 1 entry
          minY: minY,
          maxY: maxY,
          lineTouchData: LineTouchData(
            touchTooltipData: LineTouchTooltipData(
              getTooltipColor: (touchedSpot) => theme.colorScheme.surface,
              getTooltipItems: (touchedSpots) {
                return touchedSpots.map((spot) {
                  final entry = sortedEntries[spot.spotIndex];
                  final dateStr = DateFormat('MMM d').format(entry.date);
                  return LineTooltipItem(
                    '${spot.y} kg\n$dateStr',
                    theme.textTheme.labelMedium!.copyWith(fontWeight: FontWeight.bold),
                  );
                }).toList();
              },
            ),
          ),
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: 5,
            getDrawingHorizontalLine: (value) => FlLine(
              color: theme.colorScheme.surfaceContainerHighest,
              strokeWidth: 1,
              dashArray: [5, 5],
            ),
          ),
          titlesData: FlTitlesData(
            show: true,
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 40,
                interval: 5,
                getTitlesWidget: (value, meta) => Text(
                  value.toInt().toString(),
                  style: theme.textTheme.labelSmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                ),
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 22,
                getTitlesWidget: (value, meta) {
                  if (value == minX || value == maxX) {
                    final date = firstDate.add(Duration(days: value.toInt()));
                    return Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        DateFormat('MMM d').format(date),
                        style: theme.textTheme.labelSmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          ),
          borderData: FlBorderData(show: false),
          lineBarsData: [
            LineChartBarData(
              spots: spots,
              isCurved: true,
              color: AppColors.secondary,
              barWidth: 3,
              isStrokeCapRound: true,
              dotData: FlDotData(
                show: true,
                getDotPainter: (spot, percent, barData, index) => FlDotCirclePainter(
                  radius: 4,
                  color: AppColors.secondary,
                  strokeWidth: 2,
                  strokeColor: theme.colorScheme.surface,
                ),
              ),
              belowBarData: BarAreaData(
                show: true,
                gradient: LinearGradient(
                  colors: [
                    AppColors.secondary.withValues(alpha: 0.3),
                    AppColors.secondary.withValues(alpha: 0.0),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
