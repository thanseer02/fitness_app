import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fitjourney/features/progress/viewmodel/progress_viewmodel.dart';
import 'package:fitjourney/core/theme/app_colors.dart';
import 'package:fitjourney/core/theme/app_constants.dart';
import 'package:fitjourney/shared/widgets/app_button.dart';

class LogWeightSheet extends StatefulWidget {
  const LogWeightSheet({super.key});

  @override
  State<LogWeightSheet> createState() => _LogWeightSheetState();
}

class _LogWeightSheetState extends State<LogWeightSheet> {
  final _controller = TextEditingController();
  bool _isValid = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      final val = double.tryParse(_controller.text);
      setState(() {
        _isValid = val != null && val > 0 && val < 500;
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _logWeight() async {
    final val = double.tryParse(_controller.text);
    if (val != null) {
      final viewModel = context.read<ProgressViewModel>();
      await viewModel.logWeight(val);
      if (mounted) {
        Navigator.of(context).pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: EdgeInsets.only(
        top: AppSpacing.lg,
        left: AppSpacing.lg,
        right: AppSpacing.lg,
        bottom: AppSpacing.lg + MediaQuery.of(context).viewInsets.bottom,
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(bottom: AppSpacing.lg),
            decoration: BoxDecoration(
              color: theme.colorScheme.onSurfaceVariant.withOpacity(0.4),
              borderRadius: AppRadius.roundRadius,
            ),
          ),
          Text('Log Weight', style: theme.textTheme.headlineSmall),
          const SizedBox(height: AppSpacing.xl),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              SizedBox(
                width: 120,
                child: TextField(
                  controller: _controller,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  textAlign: TextAlign.center,
                  style: theme.textTheme.displayMedium?.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold),
                  decoration: InputDecoration(
                    hintText: '0.0',
                    border: InputBorder.none,
                    hintStyle: theme.textTheme.displayMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant.withOpacity(0.3)),
                  ),
                  autofocus: true,
                ),
              ),
              const SizedBox(width: AppSpacing.xs),
              Text('kg', style: theme.textTheme.titleLarge?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
            ],
          ),
          const SizedBox(height: AppSpacing.xl),
          SizedBox(
            width: double.infinity,
            child: AppButton(
              label: 'SAVE',
              variant: _isValid ? AppButtonVariant.primary : AppButtonVariant.ghost,
              onPressed: _isValid ? _logWeight : null,
            ),
          ),
        ],
      ),
    );
  }
}
