// lib/styles/button_styles.dart
import 'package:flutter/material.dart';

class ButtonStyles {
  static final ButtonStyle numericKeypadButton = ElevatedButton.styleFrom(
    textStyle: const TextStyle(fontSize: 40),
    padding: const EdgeInsets.all(20.0),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8.0),
    ),
  );

  static final ButtonStyle deleteButton = ElevatedButton.styleFrom(
    foregroundColor: Colors.white,
    backgroundColor: Colors.pink,
    textStyle: const TextStyle(fontSize: 40),
    padding: const EdgeInsets.all(20.0),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8.0),
    ),
  );

  static final ButtonStyle confirmButton = ElevatedButton.styleFrom(
    foregroundColor: Colors.white,
    backgroundColor: Colors.lightBlue,
    textStyle: const TextStyle(fontSize: 40),
    padding: const EdgeInsets.all(20.0),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8.0),
    ),
  );
}