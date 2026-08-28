import 'package:flutter/material.dart';
import '../../core/theme/app_constants.dart';

enum AppButtonVariant { primary, secondary, ghost }

class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final bool isLoading;
  final IconData? icon;

  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.isLoading = false,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    switch (variant) {
      case AppButtonVariant.primary:
        return FilledButton(
          onPressed: isLoading ? null : onPressed,
          style: FilledButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.md, horizontal: AppSpacing.lg),
            shape: RoundedRectangleBorder(borderRadius: AppRadius.smRadius),
          ),
          child: _buildContent(theme),
        );
      case AppButtonVariant.secondary:
        return OutlinedButton(
          onPressed: isLoading ? null : onPressed,
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.md, horizontal: AppSpacing.lg),
            shape: RoundedRectangleBorder(borderRadius: AppRadius.smRadius),
          ),
          child: _buildContent(theme),
        );
      case AppButtonVariant.ghost:
        return TextButton(
          onPressed: isLoading ? null : onPressed,
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.md, horizontal: AppSpacing.lg),
            shape: RoundedRectangleBorder(borderRadius: AppRadius.smRadius),
          ),
          child: _buildContent(theme),
        );
    }
  }

  Widget _buildContent(ThemeData theme) {
    if (isLoading) {
      return const SizedBox(
        height: 20,
        width: 20,
        child: CircularProgressIndicator(strokeWidth: 2),
      );
    }
    
    if (icon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 20),
          const SizedBox(width: AppSpacing.sm),
          Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
        ],
      );
    }

    return Text(label, style: const TextStyle(fontWeight: FontWeight.w600));
  }
}
