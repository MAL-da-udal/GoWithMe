import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTextStyles {
  static const headline = TextStyle(
    fontFamily: 'Montserrat',
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.text,
  );
  static const title = TextStyle(
    fontFamily: 'Montserrat',
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: AppColors.text,
  );
  static const body = TextStyle(
    fontFamily: 'Montserrat',
    fontSize: 16,
    color: AppColors.text,
  );

  static const caption = TextStyle(
    fontFamily: 'Montserrat',
    fontSize: 12,
    color: AppColors.secondaryText,
  );
}
