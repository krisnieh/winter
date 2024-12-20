// lib/widgets/vertical_icon_buttons.dart
import 'package:flutter/material.dart';

class VerticalIconButtons extends StatelessWidget {
  final VoidCallback onLightPressed;
  final VoidCallback onFanPressed;
  final VoidCallback onPower12VPressed;
  final VoidCallback onPower24VPressed;

  const VerticalIconButtons({
    Key? key,
    required this.onLightPressed,
    required this.onFanPressed,
    required this.onPower12VPressed,
    required this.onPower24VPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        IconButton(
          icon: const Icon(Icons.lightbulb),
          onPressed: onLightPressed,
        ),
        const SizedBox(height: 15),
        IconButton(
          icon: const Icon(Icons.air),
          onPressed: onFanPressed,
        ),
        const SizedBox(height: 15),
        IconButton(
          icon: const Icon(Icons.power),
          onPressed: onPower12VPressed,
        ),
        const SizedBox(height: 15),
        IconButton(
          icon: const Icon(Icons.cable),
          onPressed: onPower24VPressed,
        ),
      ],
    );
  }
}