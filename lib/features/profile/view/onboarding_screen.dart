import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fitjourney/models/user_profile.dart';
import 'package:fitjourney/features/profile/viewmodel/profile_viewmodel.dart';
import 'package:fitjourney/features/home/view/home_screen.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final _formKey = GlobalKey<FormState>();

  String _name = '';
  int _age = 0;
  double _height = 0;
  double _currentWeight = 0;
  double _targetWeight = 0;
  Goal _goal = Goal.fatLoss;
  ActivityLevel _activityLevel = ActivityLevel.sedentary;

  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final profile = UserProfile()
        ..name = _name
        ..age = _age
        ..height = _height
        ..currentWeight = _currentWeight
        ..targetWeight = _targetWeight
        ..goal = _goal
        ..activityLevel = _activityLevel;

      await ref.read(profileViewModelProvider).saveProfile(profile);

      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const HomeScreen()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).colorScheme.primaryContainer,
              Theme.of(context).scaffoldBackgroundColor,
            ],
            stops: const [0.0, 0.3],
          ),
        ),
        child: SafeArea(
          child: Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              children: [
                const Icon(Icons.fitness_center, size: 64, color: Colors.deepPurple),
                const SizedBox(height: 16),
                Text(
                  'Welcome to FitJourney!',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  'Let\'s personalize your experience.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.grey.shade600),
                ),
                const SizedBox(height: 32),
                
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _buildTextField(
                          label: 'Name',
                          icon: Icons.person,
                          validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                          onSaved: (v) => _name = v!,
                        ),
                        const SizedBox(height: 16),
                        _buildTextField(
                          label: 'Age',
                          icon: Icons.cake,
                          isNumber: true,
                          validator: (v) => v == null || int.tryParse(v) == null ? 'Invalid' : null,
                          onSaved: (v) => _age = int.parse(v!),
                        ),
                        const SizedBox(height: 16),
                        _buildTextField(
                          label: 'Height (cm)',
                          icon: Icons.height,
                          isNumber: true,
                          validator: (v) => v == null || double.tryParse(v) == null ? 'Invalid' : null,
                          onSaved: (v) => _height = double.parse(v!),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: _buildTextField(
                                label: 'Current Weight (kg)',
                                icon: Icons.scale,
                                isNumber: true,
                                validator: (v) => v == null || double.tryParse(v) == null ? 'Invalid' : null,
                                onSaved: (v) => _currentWeight = double.parse(v!),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: _buildTextField(
                                label: 'Target Weight (kg)',
                                icon: Icons.track_changes,
                                isNumber: true,
                                validator: (v) => v == null || double.tryParse(v) == null ? 'Invalid' : null,
                                onSaved: (v) => _targetWeight = double.parse(v!),
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
                          initialValue: _goal,
                          items: Goal.values.map((g) {
                            return DropdownMenuItem(value: g, child: Text(g.name.toUpperCase()));
                          }).toList(),
                          onChanged: (v) => setState(() => _goal = v!),
                        ),
                        const SizedBox(height: 16),
                        DropdownButtonFormField<ActivityLevel>(
                          decoration: InputDecoration(
                            labelText: 'Activity Level',
                            prefixIcon: const Icon(Icons.directions_run),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          initialValue: _activityLevel,
                          items: ActivityLevel.values.map((a) {
                            return DropdownMenuItem(value: a, child: Text(a.name.toUpperCase()));
                          }).toList(),
                          onChanged: (v) => setState(() => _activityLevel = v!),
                        ),
                        const SizedBox(height: 32),
                        ElevatedButton(
                          onPressed: _submit,
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
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
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
}
