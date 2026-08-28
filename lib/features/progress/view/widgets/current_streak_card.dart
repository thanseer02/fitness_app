import 'package:flutter/material.dart';
import 'package:fitjourney/models/streak_data.dart';

class CurrentStreakCard extends StatelessWidget {
  final StreakData streakData;

  const CurrentStreakCard({super.key, required this.streakData});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.orange.shade50,
      elevation: 0,
      shape: RoundedRectangleBorder(
        side: const BorderSide(color: Colors.orange, width: 2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.local_fire_department, color: Colors.orange, size: 32),
            const SizedBox(width: 12),
            Text(
              '${streakData.currentStreak} Day Streak!',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.deepOrange),
            ),
          ],
        ),
      ),
    );
  }
}
