import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fitjourney/models/user_profile.dart';
import 'package:fitjourney/features/profile/viewmodel/profile_viewmodel.dart';
import 'package:fitjourney/features/home/view/home_screen.dart';
import 'widgets/onboarding_form_card.dart';

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
                
                OnboardingFormCard(
                  initialGoal: _goal,
                  initialActivityLevel: _activityLevel,
                  onGoalChanged: (v) => setState(() => _goal = v),
                  onActivityLevelChanged: (v) => setState(() => _activityLevel = v),
                  onNameSaved: (v) => _name = v!,
                  onAgeSaved: (v) => _age = int.parse(v!),
                  onHeightSaved: (v) => _height = double.parse(v!),
                  onCurrentWeightSaved: (v) => _currentWeight = double.parse(v!),
                  onTargetWeightSaved: (v) => _targetWeight = double.parse(v!),
                  onSubmit: _submit,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
