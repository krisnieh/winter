import 'package:flutter/material.dart';

class LeftControlPanel extends StatelessWidget {
  const LeftControlPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 16,
      bottom: 16,
      child: Row(
        children: [
          FloatingActionButton(
            heroTag: 'call',
            onPressed: () {},
            backgroundColor: Colors.red[600],
            foregroundColor: Colors.white,
            child: const Icon(Icons.call),
          ),
          const SizedBox(width: 16),
          FloatingActionButton(
            heroTag: 'light',
            onPressed: () {},
            backgroundColor: Colors.amber[700],
            foregroundColor: Colors.white,
            child: const Icon(Icons.lightbulb),
          ),
          const SizedBox(width: 16),
          FloatingActionButton(
            heroTag: 'fan',
            onPressed: () {},
            backgroundColor: Colors.lightBlue,
            foregroundColor: Colors.white,
            child: const Icon(Icons.air),
          ),
        ],
      ),
    );
  }
}
