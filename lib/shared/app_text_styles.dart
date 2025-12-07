import 'package:callanalisys/shared/app_colors.dart';
import 'package:flutter/material.dart';

class AppTextStyles {
  static const TextStyle body = TextStyle(
    fontSize: 14,
    color: AppColors.textPrimary
  );

  static const TextStyle button = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: AppColors.textButton
  );

  static const TextStyle chartTextOutgoing = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: AppColors.blue
  );

  static const TextStyle chartTextIncoming = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: AppColors.primary
  );

  static const TextStyle chartTextMissed = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: Colors.redAccent
  );

  static const TextStyle chartTextUnansweredCalls = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: Colors.orangeAccent
  );

  
}