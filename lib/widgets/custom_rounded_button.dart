import 'package:flutter/material.dart';

class CustomRoundedButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String title;
  final double width;
  final double height;
  final double borderRadius;

  const CustomRoundedButton({
    required this.onPressed,
    required this.title,
    this.width = 100,
    this.height = 100,
    this.borderRadius = 10.0,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
        ),
        child: Text(title),
      ),
    );
  }
}
