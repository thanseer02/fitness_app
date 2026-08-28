import 'package:flutter/material.dart';
import 'package:fitjourney/models/user_profile.dart';

class ProfileSummaryCard extends StatelessWidget {
  final UserProfile profile;
  
  const ProfileSummaryCard({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Age: ${profile.age}'),
            Text('Height: ${profile.height} cm'),
            Text('Current Weight: ${profile.currentWeight} kg'),
            Text('Target Weight: ${profile.targetWeight} kg'),
            Text('Goal: ${profile.goal.name}'),
            Text('Activity Level: ${profile.activityLevel.name}'),
          ],
        ),
      ),
    );
  }
}
