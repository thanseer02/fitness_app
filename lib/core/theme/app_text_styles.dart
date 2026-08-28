import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppTextStyles {
  // Display Font: Outfit (Bold, energetic)
  // Body Font: Inter (Clean, readable)

  static TextStyle? _scale(TextStyle? style) {
    if (style == null) return null;
    return style.copyWith(fontSize: style.fontSize?.spMin);
  }

  static TextTheme get textTheme {
    final displayFont = GoogleFonts.outfitTextTheme();
    final bodyFont = GoogleFonts.interTextTheme();

    return displayFont.copyWith(
      displayLarge: _scale(displayFont.displayLarge?.copyWith(fontWeight: FontWeight.bold)),
      displayMedium: _scale(displayFont.displayMedium?.copyWith(fontWeight: FontWeight.bold)),
      displaySmall: _scale(displayFont.displaySmall?.copyWith(fontWeight: FontWeight.bold)),
      headlineLarge: _scale(displayFont.headlineLarge?.copyWith(fontWeight: FontWeight.w700)),
      headlineMedium: _scale(displayFont.headlineMedium?.copyWith(fontWeight: FontWeight.w700)),
      headlineSmall: _scale(displayFont.headlineSmall?.copyWith(fontWeight: FontWeight.w600)),
      titleLarge: _scale(displayFont.titleLarge?.copyWith(fontWeight: FontWeight.w600)),
      titleMedium: _scale(displayFont.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
      titleSmall: _scale(displayFont.titleSmall?.copyWith(fontWeight: FontWeight.w600)),
      
      bodyLarge: _scale(bodyFont.bodyLarge),
      bodyMedium: _scale(bodyFont.bodyMedium),
      bodySmall: _scale(bodyFont.bodySmall),
      labelLarge: _scale(bodyFont.labelLarge?.copyWith(fontWeight: FontWeight.w600)),
      labelMedium: _scale(bodyFont.labelMedium),
      labelSmall: _scale(bodyFont.labelSmall),
    );
  }
}
