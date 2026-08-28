import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fitjourney/features/profile/viewmodel/profile_viewmodel.dart';
import 'package:fitjourney/models/user_profile.dart';
import 'package:fitjourney/core/theme/app_constants.dart';
import 'package:fitjourney/shared/widgets/app_button.dart';
import 'package:fitjourney/shared/widgets/app_card.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  
  late TextEditingController _nameController;
  late TextEditingController _ageController;
  late TextEditingController _heightController;
  late TextEditingController _currentWeightController;
  late TextEditingController _targetWeightController;
  
  Goal? _selectedGoal;
  ActivityLevel? _selectedActivityLevel;
  
  UserProfile? _profile;

  @override
  void initState() {
    super.initState();
    final viewModel = context.read<ProfileViewModel>();
    _profile = viewModel.userProfile;
    
    _nameController = TextEditingController(text: _profile?.name ?? '');
    _ageController = TextEditingController(text: _profile?.age.toString() ?? '');
    _heightController = TextEditingController(text: _profile?.height.toString() ?? '');
    _currentWeightController = TextEditingController(text: _profile?.currentWeight.toString() ?? '');
    _targetWeightController = TextEditingController(text: _profile?.targetWeight.toString() ?? '');
    
    _selectedGoal = _profile?.goal ?? Goal.maintenance;
    _selectedActivityLevel = _profile?.activityLevel ?? ActivityLevel.moderate;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _heightController.dispose();
    _currentWeightController.dispose();
    _targetWeightController.dispose();
    super.dispose();
  }

  Future<void> _saveProfile() async {
    if (_formKey.currentState?.validate() ?? false) {
      final viewModel = context.read<ProfileViewModel>();
      
      final updatedProfile = _profile ?? UserProfile();
      updatedProfile
        ..name = _nameController.text.trim()
        ..age = int.parse(_ageController.text.trim())
        ..height = double.parse(_heightController.text.trim())
        ..currentWeight = double.parse(_currentWeightController.text.trim())
        ..targetWeight = double.parse(_targetWeightController.text.trim())
        ..goal = _selectedGoal!
        ..activityLevel = _selectedActivityLevel!;
        
      await viewModel.saveProfile(updatedProfile);
      
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated successfully!')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Profile')),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: EdgeInsets.all(AppSpacing.md),
            children: [
              AppCard(
                child: Column(
                  children: [
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: 'Name',
                        border: OutlineInputBorder(),
                      ),
                      validator: (val) => val == null || val.isEmpty ? 'Required' : null,
                    ),
                    SizedBox(height: AppSpacing.md),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _ageController,
                            decoration: const InputDecoration(
                              labelText: 'Age',
                              border: OutlineInputBorder(),
                            ),
                            keyboardType: TextInputType.number,
                            validator: (val) => val == null || int.tryParse(val) == null ? 'Invalid' : null,
                          ),
                        ),
                        SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: TextFormField(
                            controller: _heightController,
                            decoration: const InputDecoration(
                              labelText: 'Height (cm)',
                              border: OutlineInputBorder(),
                            ),
                            keyboardType: const TextInputType.numberWithOptions(decimal: true),
                            validator: (val) => val == null || double.tryParse(val) == null ? 'Invalid' : null,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: AppSpacing.md),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _currentWeightController,
                            decoration: const InputDecoration(
                              labelText: 'Current Weight (kg)',
                              border: OutlineInputBorder(),
                            ),
                            keyboardType: const TextInputType.numberWithOptions(decimal: true),
                            validator: (val) => val == null || double.tryParse(val) == null ? 'Invalid' : null,
                          ),
                        ),
                        SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: TextFormField(
                            controller: _targetWeightController,
                            decoration: const InputDecoration(
                              labelText: 'Target Weight (kg)',
                              border: OutlineInputBorder(),
                            ),
                            keyboardType: const TextInputType.numberWithOptions(decimal: true),
                            validator: (val) => val == null || double.tryParse(val) == null ? 'Invalid' : null,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: AppSpacing.md),
              AppCard(
                child: Column(
                  children: [
                    DropdownButtonFormField<Goal>(
                      value: _selectedGoal,
                      decoration: const InputDecoration(
                        labelText: 'Goal',
                        border: OutlineInputBorder(),
                      ),
                      items: Goal.values.map((goal) {
                        return DropdownMenuItem(
                          value: goal,
                          child: Text(goal.name.toUpperCase()),
                        );
                      }).toList(),
                      onChanged: (val) {
                        if (val != null) setState(() => _selectedGoal = val);
                      },
                    ),
                    SizedBox(height: AppSpacing.md),
                    DropdownButtonFormField<ActivityLevel>(
                      value: _selectedActivityLevel,
                      decoration: const InputDecoration(
                        labelText: 'Activity Level',
                        border: OutlineInputBorder(),
                      ),
                      items: ActivityLevel.values.map((level) {
                        return DropdownMenuItem(
                          value: level,
                          child: Text(level.name.toUpperCase()),
                        );
                      }).toList(),
                      onChanged: (val) {
                        if (val != null) setState(() => _selectedActivityLevel = val);
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(height: AppSpacing.xl),
              AppButton(
                label: 'SAVE CHANGES',
                onPressed: _saveProfile,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
