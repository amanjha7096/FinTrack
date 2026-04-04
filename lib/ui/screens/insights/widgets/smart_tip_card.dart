import 'package:flutter/material.dart';

class SmartTipCard extends StatelessWidget {
  const SmartTipCard({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final background = text.contains('Great work')
        ? Theme.of(context).colorScheme.primaryContainer
        : text.contains('exceeded') || text.contains('jumped')
            ? Colors.orange.withOpacity(0.2)
            : Theme.of(context).dividerColor.withOpacity(0.2);
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            const Icon(Icons.lightbulb_outline),
            const SizedBox(width: 12),
            Expanded(
              child: Text(text, style: Theme.of(context).textTheme.bodyMedium),
            ),
          ],
        ),
      ),
    );
  }
}