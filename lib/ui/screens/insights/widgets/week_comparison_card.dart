import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../logic/insights_cubit/insights_state.dart';

class WeekComparisonCard extends StatelessWidget {
  const WeekComparisonCard({super.key, required this.state});

  final InsightsState state;

  @override
  Widget build(BuildContext context) {
    final change = state.weekChangePercent;
    final isPositive = change <= 0;
    final arrow = isPositive ? Icons.arrow_upward : Icons.arrow_downward;
    final color = isPositive ? AppColors.income : AppColors.expense;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
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
                Container(width: 1, height: 56, color: Theme.of(context).dividerColor),
                Expanded(
                  child: _WeekValue(label: 'Last week', value: state.lastWeekTotal),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(arrow, size: 14, color: color),
                      const SizedBox(width: 6),
                      Text(
                        '${change.abs().toStringAsFixed(0)}%',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: color),
                      ),
                    ],
                  ),
                ),
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
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(label, style: Theme.of(context).textTheme.bodySmall),
        const SizedBox(height: 4),
        Text(
          CurrencyFormatter.format(value),
          style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
        ),
      ],
    );
  }
}
