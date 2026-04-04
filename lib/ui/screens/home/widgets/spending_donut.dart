import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

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
    final expenseTransactions = widget.transactions.where((tx) => tx.type == 'expense').toList();
    final totals = <String, double>{};
    for (final tx in expenseTransactions) {
      totals[tx.category] = (totals[tx.category] ?? 0) + tx.amount;
    }
    final selectedKey = _selectedCategoryKey(totals);
    final sections = totals.entries.map((entry) {
      final category = Categories.byKey(entry.key);
      final isSelected = entry.key == selectedKey;
      return PieChartSectionData(
        color: category?.color ?? Theme.of(context).colorScheme.primary,
        value: entry.value,
        radius: isSelected ? 70 : 60,
        title: '',
      );
    }).toList();

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Spending breakdown', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            SizedBox(
              height: 220,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  PieChart(
                    PieChartData(
                      sectionsSpace: 2,
                      centerSpaceRadius: 48,
                      sections: sections.isEmpty
                          ? [
                              PieChartSectionData(
                                color: Theme.of(context).dividerColor,
                                value: 1,
                                radius: 60,
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
                  ),
                  _buildCenterLabel(context, totals, selectedKey),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _selectedCategoryKey(Map<String, double> totals) {
    if (_touchedIndex < 0) {
      return '';
    }
    final keys = totals.keys.toList();
    if (_touchedIndex >= keys.length) {
      return '';
    }
    return keys[_touchedIndex];
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
          Text(CurrencyFormatter.format(total), style: Theme.of(context).textTheme.titleMedium),
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
        Text(CurrencyFormatter.format(amount), style: Theme.of(context).textTheme.titleMedium),
      ],
    );
  }
}