import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/utils/currency_formatter.dart';
import '../../../../logic/goal_bloc/goal_state.dart';

class GoalProgressPill extends StatelessWidget {
  const GoalProgressPill({
    super.key,
    required this.goalState,
  });

  final GoalLoaded goalState;

  @override
  Widget build(BuildContext context) {
    final goalAmount = goalState.settings.savingsGoalAmount;
    final saved = goalState.savedThisMonth;
    final progress = goalState.goalProgress.clamp(0.0, 1.0).toDouble();
    return InkWell(
      onTap: () => context.go('/goals'),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primaryContainer,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Saved ${CurrencyFormatter.format(saved)} of ${CurrencyFormatter.format(goalAmount)} goal',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: progress.isNaN ? 0.0 : progress,
                minHeight: 6,
                backgroundColor: Theme.of(context).dividerColor,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}