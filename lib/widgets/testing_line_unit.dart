// lib/widgets/custom_chip.dart
import 'package:flutter/material.dart';

class CustomChip extends StatelessWidget {
  final String label;
  final String avatarText;
  final VoidCallback onDeleted;

  const CustomChip({
    Key? key,
    required this.label,
    required this.avatarText,
    required this.onDeleted,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(label),
      avatar: CircleAvatar(
        backgroundColor: Colors.blue.shade900,
        child: Text(avatarText),
      ),
      deleteIcon: Icon(Icons.cancel),
      onDeleted: onDeleted,
    );
  }
}