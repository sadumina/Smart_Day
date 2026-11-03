import 'package:flutter/material.dart';

class PriorityChip extends StatelessWidget {
  const PriorityChip({required this.priority, super.key});

  final String priority;

  @override
  Widget build(BuildContext context) {
    final normalized = priority.toLowerCase();
    final (color, label) = switch (normalized) {
      'high' => (Colors.red, 'High'),
      'medium' => (Colors.amber.shade800, 'Medium'),
      _ => (Colors.green.shade700, 'Low'),
    };
    return Chip(
      label: Text(label),
      labelStyle: TextStyle(color: color, fontSize: 12),
      backgroundColor: color.withValues(alpha: 0.12),
      side: BorderSide.none,
      visualDensity: VisualDensity.compact,
    );
  }
}
