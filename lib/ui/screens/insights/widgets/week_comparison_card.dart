import 'package:flutter/material.dart';

import '../../../../core/utils/currency_formatter.dart';
import '../../../../logic/insights_cubit/insights_state.dart';

class WeekComparisonCard extends StatelessWidget {
  const WeekComparisonCard({super.key, required this.state});

  final InsightsState state;

  @override
  Widget build(BuildContext context) {
    final change = state.weekChangePercent;
    final isPositive = change >= 0;
    final arrow = isPositive ? Icons.arrow_upward : Icons.arrow_downward;
    final color = isPositive ? Theme.of(context).colorScheme.error : Theme.of(context).colorScheme.primary;
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('This week vs last week', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _WeekValue(label: 'This week', value: state.thisWeekTotal),
                ),
                Expanded(
                  child: _WeekValue(label: 'Last week', value: state.lastWeekTotal),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(arrow, size: 16, color: color),
                const SizedBox(width: 6),
                Text('${change.abs().toStringAsFixed(0)}%', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: color)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _WeekValue extends StatelessWidget {
  const _WeekValue({required this.label, required this.value});

  final String label;
  final double value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.bodySmall),
        const SizedBox(height: 4),
        Text(CurrencyFormatter.format(value), style: Theme.of(context).textTheme.titleMedium),
      ],
    );
  }
}