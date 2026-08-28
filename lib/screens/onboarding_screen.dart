import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user_profile.dart';
import '../providers/user_profile_provider.dart';
import 'home_screen.dart';

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

      await ref.read(userProfileNotifierProvider.notifier).saveProfile(profile);

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
      appBar: AppBar(title: const Text('Setup Profile')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              decoration: const InputDecoration(labelText: 'Name'),
              validator: (v) => v == null || v.isEmpty ? 'Required' : null,
              onSaved: (v) => _name = v!,
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Age'),
              keyboardType: TextInputType.number,
              validator: (v) => v == null || int.tryParse(v) == null ? 'Invalid' : null,
              onSaved: (v) => _age = int.parse(v!),
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Height (cm)'),
              keyboardType: TextInputType.number,
              validator: (v) => v == null || double.tryParse(v) == null ? 'Invalid' : null,
              onSaved: (v) => _height = double.parse(v!),
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Current Weight (kg)'),
              keyboardType: TextInputType.number,
              validator: (v) => v == null || double.tryParse(v) == null ? 'Invalid' : null,
              onSaved: (v) => _currentWeight = double.parse(v!),
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Target Weight (kg)'),
              keyboardType: TextInputType.number,
              validator: (v) => v == null || double.tryParse(v) == null ? 'Invalid' : null,
              onSaved: (v) => _targetWeight = double.parse(v!),
            ),
            const SizedBox(height: 16),
            const Text('Goal:'),
            ...Goal.values.map(
              (g) => RadioListTile<Goal>(
                title: Text(g.name),
                value: g,
                groupValue: _goal,
                onChanged: (v) => setState(() => _goal = v!),
              ),
            ),
            const SizedBox(height: 16),
            const Text('Activity Level:'),
            ...ActivityLevel.values.map(
              (a) => RadioListTile<ActivityLevel>(
                title: Text(a.name),
                value: a,
                groupValue: _activityLevel,
                onChanged: (v) => setState(() => _activityLevel = v!),
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _submit,
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
