import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/categories.dart';

class CategoryBarChart extends StatelessWidget {
  const CategoryBarChart({super.key, required this.expenseByCategory});

  final Map<String, double> expenseByCategory;

  String _shortLabel(String label) {
    if (label.length <= 12) {
      return label;
    }
    
    return '${label.substring(0, 8)}…';
  }

  @override
  Widget build(BuildContext context) {
    final entries = expenseByCategory.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    final topEntries = entries.take(6).toList();
    final max = topEntries.isEmpty ? 1.0 : topEntries.first.value;
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
            Text('Top categories', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            SizedBox(
              height: 220,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  groupsSpace: 14,
                  barGroups: topEntries.isEmpty
                      ? [
                          BarChartGroupData(
                            x: 0,
                            barRods: [
                              BarChartRodData(
                                toY: 1,
                                color: Theme.of(context).dividerColor,
                                width: 18,
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ],
                          )
                        ]
                      : topEntries.asMap().entries.map((entry) {
                          final category = Categories.byKey(entry.value.key);
                          return BarChartGroupData(
                            x: entry.key,
                            barRods: [
                              BarChartRodData(
                                toY: entry.value.value,
                                width: 18,
                                color: category?.color ?? Theme.of(context).colorScheme.primary,
                                backDrawRodData: BackgroundBarChartRodData(
                                  show: true,
                                  toY: max,
                                  color: (Theme.of(context).brightness == Brightness.dark
                                          ? AppColors.darkBorder
                                          : AppColors.lightBorder)
                                      .withValues(alpha: 0.5),
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ],
                          );
                        }).toList(),
                  titlesData: FlTitlesData(
                    leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 88,
                        getTitlesWidget: (value, meta) {
                          final index = value.toInt();
                          if (index < 0 || index >= topEntries.length) return const SizedBox.shrink();
                          final category = Categories.byKey(topEntries[index].key);
                          return SideTitleWidget(
                            meta: meta,
                            space: 10,
                            child: RotatedBox(
                              quarterTurns: 3,
                              child: SizedBox(
                                width: 72,
                                child: Text(
                                  _shortLabel(category?.label ?? ''),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.left,
                                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w600,
                                        color: Theme.of(context).brightness == Brightness.dark
                                            ? AppColors.darkText
                                            : AppColors.lightText,
                                      ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  gridData: const FlGridData(show: false),
                  borderData: FlBorderData(show: false),
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
