// lib/styles/button_styles.dart
import 'package:flutter/material.dart';

class ButtonStyles {
  static final ButtonStyle numericKeypadButton = ElevatedButton.styleFrom(
    // minimumSize: const Size(100, 100), // Set the button size
    // padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0), // Set the text padding
    textStyle: const TextStyle(fontSize: 22),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8.0),
    ),
  );

  static final ButtonStyle deleteButton = ElevatedButton.styleFrom(
    foregroundColor: Colors.white,
    backgroundColor: Colors.pink,
    // minimumSize: const Size(100, 100), // Set the button size
    // padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0), // Set the text padding
    textStyle: const TextStyle(fontSize: 22),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8.0),
    ),
  );

  static final ButtonStyle confirmButton = ElevatedButton.styleFrom(
    foregroundColor: Colors.white,
    backgroundColor: Colors.lightGreen,
    // minimumSize: const Size(100, 100), // Set the button size
    // padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0), // Set the text padding
    textStyle: const TextStyle(fontSize: 22),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8.0),
    ),
  );
}