import 'package:flutter/material.dart';
import 'package:fitjourney/models/user_profile.dart';

class OnboardingFormCard extends StatelessWidget {
  final Goal initialGoal;
  final ActivityLevel initialActivityLevel;
  final ValueChanged<Goal> onGoalChanged;
  final ValueChanged<ActivityLevel> onActivityLevelChanged;
  final FormFieldSetter<String> onNameSaved;
  final FormFieldSetter<String> onAgeSaved;
  final FormFieldSetter<String> onHeightSaved;
  final FormFieldSetter<String> onCurrentWeightSaved;
  final FormFieldSetter<String> onTargetWeightSaved;
  final VoidCallback onSubmit;

  const OnboardingFormCard({
    super.key,
    required this.initialGoal,
    required this.initialActivityLevel,
    required this.onGoalChanged,
    required this.onActivityLevelChanged,
    required this.onNameSaved,
    required this.onAgeSaved,
    required this.onHeightSaved,
    required this.onCurrentWeightSaved,
    required this.onTargetWeightSaved,
    required this.onSubmit,
  });

  Widget _buildTextField(
    BuildContext context, {
    required String label,
    required IconData icon,
    bool isNumber = false,
    required FormFieldValidator<String> validator,
    required FormFieldSetter<String> onSaved,
  }) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: Theme.of(context).colorScheme.surface,
      ),
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      validator: validator,
      onSaved: onSaved,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildTextField(
              context,
              label: 'Name',
              icon: Icons.person,
              validator: (v) => v == null || v.isEmpty ? 'Required' : null,
              onSaved: onNameSaved,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              context,
              label: 'Age',
              icon: Icons.cake,
              isNumber: true,
              validator: (v) => v == null || int.tryParse(v) == null ? 'Invalid' : null,
              onSaved: onAgeSaved,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              context,
              label: 'Height (cm)',
              icon: Icons.height,
              isNumber: true,
              validator: (v) => v == null || double.tryParse(v) == null ? 'Invalid' : null,
              onSaved: onHeightSaved,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildTextField(
                    context,
                    label: 'Current Weight (kg)',
                    icon: Icons.scale,
                    isNumber: true,
                    validator: (v) => v == null || double.tryParse(v) == null ? 'Invalid' : null,
                    onSaved: onCurrentWeightSaved,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildTextField(
                    context,
                    label: 'Target Weight (kg)',
                    icon: Icons.track_changes,
                    isNumber: true,
                    validator: (v) => v == null || double.tryParse(v) == null ? 'Invalid' : null,
                    onSaved: onTargetWeightSaved,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            DropdownButtonFormField<Goal>(
              decoration: InputDecoration(
                labelText: 'Primary Goal',
                prefixIcon: const Icon(Icons.flag),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              initialValue: initialGoal,
              items: Goal.values.map((g) {
                return DropdownMenuItem(value: g, child: Text(g.name.toUpperCase()));
              }).toList(),
              onChanged: (v) => onGoalChanged(v!),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<ActivityLevel>(
              decoration: InputDecoration(
                labelText: 'Activity Level',
                prefixIcon: const Icon(Icons.directions_run),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              initialValue: initialActivityLevel,
              items: ActivityLevel.values.map((a) {
                return DropdownMenuItem(value: a, child: Text(a.name.toUpperCase()));
              }).toList(),
              onChanged: (v) => onActivityLevelChanged(v!),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: onSubmit,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Theme.of(context).colorScheme.onPrimary,
              ),
              child: const Text('Start Journey', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }
}
