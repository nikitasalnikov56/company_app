import 'package:flutter/material.dart';
import 'package:flutter_application_1/ui/style/app_colors.dart';

abstract class AppStyle {
  static const TextStyle fontStyle =  TextStyle(
    fontSize: 34,
    color: AppColors.mainColor,
    fontWeight: FontWeight.bold,
  );
}
