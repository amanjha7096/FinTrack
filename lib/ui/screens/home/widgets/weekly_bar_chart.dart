import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/date_helpers.dart';
import '../../../../data/models/transaction_model.dart';

class WeeklyBarChart extends StatelessWidget {
  const WeeklyBarChart({
    super.key,
    required this.transactions,
  });

  final List<TransactionModel> transactions;

  @override
  Widget build(BuildContext context) {
    final today = DateHelpers.normalizeDate(DateTime.now());
    final start = today.subtract(const Duration(days: 6));
    final days = List.generate(7, (index) => start.add(Duration(days: index)));
    final totals = <DateTime, double>{};
    for (final day in days) {
      totals[day] = 0;
    }
    for (final tx in transactions) {
      if (tx.type != 'expense') continue;
      final date = DateHelpers.normalizeDate(tx.date);
      if (date.isBefore(start) || date.isAfter(today)) continue;
      totals[date] = (totals[date] ?? 0) + tx.amount;
    }

    final maxY = totals.values.fold<double>(0, (max, value) => value > max ? value : max);

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
            Row(
              children: [
                Text('Weekly spending', style: Theme.of(context).textTheme.titleMedium),
                const Spacer(),
                Text('Last 7 days', style: Theme.of(context).textTheme.labelSmall),
              ],
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 200,
              child: BarChart(
                BarChartData(
                  maxY: maxY == 0 ? 1 : maxY * 1.2,
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    getDrawingHorizontalLine: (_) => FlLine(
                      color: (Theme.of(context).brightness == Brightness.dark
                              ? AppColors.darkBorder
                              : AppColors.lightBorder)
                          .withValues(alpha: 0.25),
                      strokeWidth: 0.5,
                    ),
                  ),
                  titlesData: FlTitlesData(
                    leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          final index = value.toInt();
                          if (index < 0 || index >= days.length) return const SizedBox.shrink();
                          final day = days[index];
                          final label = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'][day.weekday - 1];
                          return Padding(
                            padding: const EdgeInsets.only(top: 6),
                            child: Text(label, style: Theme.of(context).textTheme.labelSmall),
                          );
                        },
                      ),
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  barGroups: List.generate(days.length, (index) {
                    final day = days[index];
                    final value = totals[day] ?? 0;
                    final isToday = day == today;
                    return BarChartGroupData(
                      x: index,
                      barRods: [
                        BarChartRodData(
                          toY: value,
                          width: 18,
                          color: isToday
                              ? AppColors.income
                              : AppColors.gradientBlueStart.withValues(alpha: 0.45),
                          backDrawRodData: BackgroundBarChartRodData(
                            show: true,
                            toY: maxY == 0 ? 1 : maxY * 1.2,
                            color: (Theme.of(context).brightness == Brightness.dark
                                    ? AppColors.darkBorder
                                    : AppColors.lightBorder)
                                .withValues(alpha: 0.45),
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ],
                    );
                  }),
                ),
                duration: const Duration(milliseconds: 800),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
