import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/date_helpers.dart';
import '../../../../logic/goal_bloc/goal_state.dart';

class StreakHeatmap extends StatelessWidget {
  const StreakHeatmap({super.key, required this.state});

  final GoalLoaded state;

  @override
  Widget build(BuildContext context) {
    final today = DateHelpers.normalizeDate(DateTime.now());
    final days = List.generate(84, (index) => today.subtract(Duration(days: 83 - index)));
    final noSpendDays = state.noSpendDays.map(DateHelpers.normalizeDate).toSet();
    final expenseTotals = <DateTime, double>{};
    state.dailyExpenseTotals.forEach((key, value) {
      expenseTotals[DateHelpers.normalizeDate(key)] = value;
    });
    final maxSpend = expenseTotals.values.fold<double>(0, (max, value) => value > max ? value : max);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final flameColor = state.currentStreak == 0
        ? (isDark ? AppColors.darkTextHint : AppColors.lightTextHint)
        : AppColors.warning;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
        Row(
          children: [
            Icon(Icons.local_fire_department, color: flameColor, size: 34),
            const SizedBox(width: 6),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${state.currentStreak}',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w800),
                ),
                Text('day streak', style: Theme.of(context).textTheme.bodyMedium),
              ],
            ),
            const Spacer(),
            _LegendDot(color: AppColors.income, label: 'No spend'),
            const SizedBox(width: 12),
            _LegendDot(color: AppColors.expense.withValues(alpha: 0.35), label: 'Spend'),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 7 * 32,
          child: GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 12,
              crossAxisSpacing: 4,
              mainAxisSpacing: 4,
              childAspectRatio: 1,
            ),
            itemCount: days.length,
            itemBuilder: (context, index) {
              final date = days[index];
              final isFuture = date.isAfter(today);
              final isNoSpend = noSpendDays.contains(date);
              final isToday = DateUtils.isSameDay(date, today);
              final spendAmount = expenseTotals[date] ?? 0;
              final spendRatio = maxSpend == 0 ? 0.0 : (spendAmount / maxSpend).clamp(0.0, 1.0);
              final spendColor = AppColors.expense.withValues(alpha: 0.35 + (spendRatio * 0.65));
              final color = isFuture
                  ? Colors.transparent
                  : isNoSpend
                      ? AppColors.income
                      : spendColor;
              return Tooltip(
                message:
                    '${date.day}/${date.month} ${isNoSpend ? 'No spend' : 'Spent ₹${spendAmount.toStringAsFixed(0)}'}',
                child: Container(
                  height: 28,
                  width: 28,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                      color: isToday
                          ? AppColors.softIvory
                          : isFuture
                              ? Theme.of(context).dividerColor
                              : Colors.transparent,
                      width: isToday ? 1.5 : 1,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    ));
  }
}

class _LegendDot extends StatelessWidget {
  const _LegendDot({required this.color, required this.label});

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(label, style: Theme.of(context).textTheme.labelSmall),
      ],
    );
  }
}
