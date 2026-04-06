import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/categories.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../data/models/transaction_model.dart';

class SpendingDonut extends StatefulWidget {
  const SpendingDonut({
    super.key,
    required this.transactions,
  });

  final List<TransactionModel> transactions;

  @override
  State<SpendingDonut> createState() => _SpendingDonutState();
}

class _SpendingDonutState extends State<SpendingDonut> {
  int _touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    final reduced = MediaQuery.of(context).disableAnimations;
    final expenseTransactions = widget.transactions.where((tx) => tx.type == 'expense').toList();
    final totals = <String, double>{};
    for (final tx in expenseTransactions) {
      totals[tx.category] = (totals[tx.category] ?? 0) + tx.amount;
    }
    final sortedEntries = totals.entries.toList()..sort((a, b) => b.value.compareTo(a.value));
    final selectedKey = _selectedCategoryKey(sortedEntries);
    final sections = sortedEntries.map((entry) {
      final category = Categories.byKey(entry.key);
      final isSelected = entry.key == selectedKey;
      return PieChartSectionData(
        color: category?.color ?? Theme.of(context).colorScheme.primary,
        value: entry.value,
        radius: isSelected ? 72 : 62,
        title: '',
        borderSide: BorderSide(
          color: isSelected ? AppColors.softIvory.withValues(alpha: 0.45) : Colors.transparent,
          width: isSelected ? 2 : 0,
        ),
      );
    }).toList();

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
                Text('Spending breakdown', style: Theme.of(context).textTheme.titleMedium),
                const Spacer(),
                Text('${sortedEntries.length} categories', style: Theme.of(context).textTheme.labelSmall),
              ],
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 220,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  PieChart(
                    PieChartData(
                      sectionsSpace: 3,
                      centerSpaceRadius: 50,
                      sections: sections.isEmpty
                          ? [
                              PieChartSectionData(
                                color: Theme.of(context).dividerColor,
                                value: 1,
                                radius: 62,
                                title: '',
                              ),
                            ]
                          : sections,
                      pieTouchData: PieTouchData(
                        touchCallback: (event, response) {
                          if (!event.isInterestedForInteractions || response?.touchedSection == null) {
                            setState(() => _touchedIndex = -1);
                            return;
                          }
                          setState(() => _touchedIndex = response!.touchedSection!.touchedSectionIndex);
                        },
                      ),
                    ),
                    duration: reduced ? Duration.zero : const Duration(milliseconds: 800),
                  ),
                  _buildCenterLabel(context, totals, selectedKey),
                ],
              ),
            ),
            if (sortedEntries.isNotEmpty) ...[
              const SizedBox(height: 14),
              LayoutBuilder(
                builder: (context, constraints) {
                  final itemWidth = (constraints.maxWidth - 12) / 2;
                  return Wrap(
                    runSpacing: 10,
                    spacing: 12,
                    children: sortedEntries.map((entry) {
                      final category = Categories.byKey(entry.key);
                      final accent = category?.color ?? AppColors.income;
                      final total = totals.values.fold<double>(0, (sum, value) => sum + value);
                      final share = total == 0 ? 0 : (entry.value / total) * 100;
                      final active = selectedKey == entry.key;
                      return SizedBox(
                        width: itemWidth,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                          decoration: BoxDecoration(
                            color: active
                                ? accent.withValues(alpha: 0.12)
                                : Theme.of(context).brightness == Brightness.dark
                                    ? AppColors.darkCardAlt
                                    : AppColors.lightCardAlt,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: active ? accent.withValues(alpha: 0.45) : Theme.of(context).dividerColor,
                            ),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 10,
                                height: 10,
                                decoration: BoxDecoration(
                                  color: accent,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      category?.label ?? entry.key,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                            fontWeight: FontWeight.w600,
                                          ),
                                    ),
                                    Text(
                                      '${share.toStringAsFixed(0)}%',
                                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                            color: accent,
                                            fontWeight: FontWeight.w700,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  );
                },
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _selectedCategoryKey(List<MapEntry<String, double>> entries) {
    if (_touchedIndex < 0) {
      return '';
    }
    if (_touchedIndex >= entries.length) {
      return '';
    }
    return entries[_touchedIndex].key;
  }

  Widget _buildCenterLabel(
    BuildContext context,
    Map<String, double> totals,
    String selectedKey,
  ) {
    if (selectedKey.isEmpty) {
      final total = totals.values.fold(0.0, (sum, value) => sum + value);
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Total', style: Theme.of(context).textTheme.bodySmall),
          const SizedBox(height: 4),
          Text(
            CurrencyFormatter.format(total),
            style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
        ],
      );
    }
    final category = Categories.byKey(selectedKey);
    final amount = totals[selectedKey] ?? 0;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(category?.label ?? '', style: Theme.of(context).textTheme.bodySmall),
        const SizedBox(height: 4),
        Text(
          CurrencyFormatter.format(amount),
          style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
        ),
      ],
    );
  }
}
