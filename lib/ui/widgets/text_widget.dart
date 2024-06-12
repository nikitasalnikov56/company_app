import 'package:flutter/material.dart';

class TextWidget extends StatelessWidget {
  const TextWidget({
    super.key,
    required this.text,
    required this.backgroundColor,
    this.fontWeight,
    this.color,
  });

  final String text;
  final FontWeight? fontWeight;
  final Color backgroundColor;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 18,
        fontWeight: fontWeight,
        backgroundColor: backgroundColor,
        color: color,
      ),
    );
  }
}