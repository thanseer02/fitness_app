import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fitjourney/features/progress/viewmodel/progress_viewmodel.dart';

class WeeklyCheckInScreen extends StatefulWidget {
  const WeeklyCheckInScreen({super.key});

  @override
  State<WeeklyCheckInScreen> createState() => _WeeklyCheckInScreenState();
}

class _WeeklyCheckInScreenState extends State<WeeklyCheckInScreen> {
  double _weight = 0;
  bool _isSaving = false;

  Future<void> _saveWeight() async {
    if (_weight <= 0) return;

    setState(() => _isSaving = true);

    await context.read<ProgressViewModel>().logWeight(_weight);

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
