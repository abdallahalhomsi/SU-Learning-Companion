import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTextStyles {
  AppTextStyles._();

  static const TextStyle appBarTitle = TextStyle(
    color: AppColors.textOnPrimary,
    fontSize: 18,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle listButton = TextStyle(
    color: AppColors.textOnPrimary,
    fontSize: 14,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle primaryButton = TextStyle(
    color: AppColors.textOnPrimary,
    fontSize: 15,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle errorText = TextStyle(
    color: AppColors.errorRed,
    fontSize: 12,
  );
}