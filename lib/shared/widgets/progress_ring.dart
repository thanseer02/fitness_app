import 'package:flutter/material.dart';

class ProgressRing extends StatelessWidget {
  final double progress; // 0.0 to 1.0
  final double size;
  final double strokeWidth;
  final Color? color;
  final Color? backgroundColor;
  final Widget? centerWidget;

  const ProgressRing({
    super.key,
    required this.progress,
    this.size = 100.0,
    this.strokeWidth = 8.0,
    this.color,
    this.backgroundColor,
    this.centerWidget,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final activeColor = color ?? theme.colorScheme.primary;
    final bgColor = backgroundColor ?? theme.colorScheme.surfaceVariant;

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        fit: StackFit.expand,
        children: [
          CircularProgressIndicator(
            value: progress.clamp(0.0, 1.0),
            strokeWidth: strokeWidth,
            valueColor: AlwaysStoppedAnimation<Color>(activeColor),
            backgroundColor: bgColor,
            strokeCap: StrokeCap.round,
          ),
          if (centerWidget != null)
            Center(child: centerWidget!),
        ],
      ),
    );
  }
}
