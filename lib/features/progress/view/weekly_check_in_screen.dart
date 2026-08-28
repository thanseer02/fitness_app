import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fitjourney/models/weight_entry.dart';
import 'package:fitjourney/core/di/isar_provider.dart';
import 'package:fitjourney/features/profile/viewmodel/user_profile_provider.dart';
import 'package:fitjourney/features/progress/viewmodel/progress_provider.dart';

class WeeklyCheckInScreen extends ConsumerStatefulWidget {
  const WeeklyCheckInScreen({super.key});

  @override
  ConsumerState<WeeklyCheckInScreen> createState() => _WeeklyCheckInScreenState();
}

class _WeeklyCheckInScreenState extends ConsumerState<WeeklyCheckInScreen> {
  double _weight = 0;
  bool _isSaving = false;

  Future<void> _saveWeight() async {
    if (_weight <= 0) return;

    setState(() => _isSaving = true);

    final isar = await ref.read(isarProvider.future);
    
    // Save WeightEntry
    final entry = WeightEntry()
      ..date = DateTime.now()
      ..weight = _weight;

    await isar.writeTxn(() async {
      await isar.weightEntrys.put(entry);
    });

    // Update UserProfile current weight
    final profileNotifier = ref.read(userProfileNotifierProvider.notifier);
    final profile = ref.read(userProfileNotifierProvider).value;
    
    if (profile != null) {
      profile.currentWeight = _weight;
      await profileNotifier.saveProfile(profile);
    }

    // Refresh history provider
    ref.invalidate(weightHistoryProvider);

    if (mounted) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Weight Check-in Saved!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Weekly Check-in')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.monitor_weight, size: 64, color: Colors.blue),
            const SizedBox(height: 24),
            Text('Log your current weight', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 24),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Current Weight (kg)',
                border: OutlineInputBorder(),
                suffixText: 'kg',
              ),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              onChanged: (val) {
                setState(() {
                  _weight = double.tryParse(val) ?? 0;
                });
              },
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isSaving || _weight <= 0 ? null : _saveWeight,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  textStyle: const TextStyle(fontSize: 18),
                ),
                child: _isSaving 
                    ? const CircularProgressIndicator() 
                    : const Text('Save Check-in'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
