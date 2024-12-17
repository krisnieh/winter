// lib/styles/button_styles.dart
import 'package:flutter/material.dart';

class ButtonStyles {
  static final ButtonStyle numericKeypadButton = ElevatedButton.styleFrom(
    textStyle: const TextStyle(fontSize: 24),
    padding: const EdgeInsets.all(16.0),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8.0),
    ),
  );

  static final ButtonStyle deleteButton = ElevatedButton.styleFrom(
    backgroundColor: Colors.red,
    textStyle: const TextStyle(fontSize: 24),
    padding: const EdgeInsets.all(16.0),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8.0),
    ),
  );

  static final ButtonStyle confirmButton = ElevatedButton.styleFrom(
    backgroundColor: Colors.green,
    textStyle: const TextStyle(fontSize: 24),
    padding: const EdgeInsets.all(16.0),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8.0),
    ),
  );
}