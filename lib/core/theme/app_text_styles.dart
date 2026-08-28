import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTextStyles {
  // Display Font: Outfit (Bold, energetic)
  // Body Font: Inter (Clean, readable)

  static TextTheme get textTheme {
    final displayFont = GoogleFonts.outfitTextTheme();
    final bodyFont = GoogleFonts.interTextTheme();

    return displayFont.copyWith(
      displayLarge: displayFont.displayLarge?.copyWith(fontWeight: FontWeight.bold),
      displayMedium: displayFont.displayMedium?.copyWith(fontWeight: FontWeight.bold),
      displaySmall: displayFont.displaySmall?.copyWith(fontWeight: FontWeight.bold),
      headlineLarge: displayFont.headlineLarge?.copyWith(fontWeight: FontWeight.w700),
      headlineMedium: displayFont.headlineMedium?.copyWith(fontWeight: FontWeight.w700),
      headlineSmall: displayFont.headlineSmall?.copyWith(fontWeight: FontWeight.w600),
      titleLarge: displayFont.titleLarge?.copyWith(fontWeight: FontWeight.w600),
      titleMedium: displayFont.titleMedium?.copyWith(fontWeight: FontWeight.w600),
      titleSmall: displayFont.titleSmall?.copyWith(fontWeight: FontWeight.w600),
      
      bodyLarge: bodyFont.bodyLarge,
      bodyMedium: bodyFont.bodyMedium,
      bodySmall: bodyFont.bodySmall,
      labelLarge: bodyFont.labelLarge?.copyWith(fontWeight: FontWeight.w600),
      labelMedium: bodyFont.labelMedium,
      labelSmall: bodyFont.labelSmall,
    );
  }
}
