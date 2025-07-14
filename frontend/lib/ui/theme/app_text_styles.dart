import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTextStyles {
  static const headline = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.text,
  );
  static const title = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: AppColors.text,
  );
  static const body = TextStyle(fontSize: 16, color: AppColors.text);

  static const caption = TextStyle(
    fontSize: 12,
    color: AppColors.secondaryText,
  );
}
