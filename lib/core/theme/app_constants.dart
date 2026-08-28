import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppSpacing {
  static double get xs => 4.0.w;
  static double get sm => 8.0.w;
  static double get md => 16.0.w;
  static double get lg => 24.0.w;
  static double get xl => 32.0.w;
  static double get xxl => 48.0.w;
}

class AppRadius {
  static double get sm => 8.0.r;
  static double get md => 12.0.r;
  static double get lg => 16.0.r;
  static double get xl => 24.0.r;
  static double get round => 99.0.r;

  static BorderRadius get smRadius => BorderRadius.all(Radius.circular(sm));
  static BorderRadius get mdRadius => BorderRadius.all(Radius.circular(md));
  static BorderRadius get lgRadius => BorderRadius.all(Radius.circular(lg));
  static BorderRadius get xlRadius => BorderRadius.all(Radius.circular(xl));
  static BorderRadius get roundRadius => BorderRadius.all(Radius.circular(round));
}
