import 'package:flutter/material.dart';

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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text('${state.currentStreak}', style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(width: 6),
            const Icon(Icons.local_fire_department, color: Colors.orange),
            const SizedBox(width: 6),
            Text('day streak', style: Theme.of(context).textTheme.bodyMedium),
            const Spacer(),
            _LegendDot(color: const Color(0xFF1D9E75), label: 'No spend'),
            const SizedBox(width: 12),
            _LegendDot(color: const Color(0xFFFCE5E5), label: 'Low spend'),
            const SizedBox(width: 8),
            _LegendDot(color: const Color(0xFFE24B4A), label: 'High spend'),
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
              final spendColor = Color.lerp(const Color(0xFFFCE5E5), const Color(0xFFE24B4A), spendRatio)!;
              final color = isFuture
                  ? Colors.transparent
                  : isNoSpend
                      ? const Color(0xFF1D9E75)
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
                      color: isToday ? const Color(0xFF1D9E75) : Colors.grey.shade400,
                      width: isToday ? 2 : 1,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
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