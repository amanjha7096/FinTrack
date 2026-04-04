import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/categories.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../data/models/budget_limit_model.dart';
import '../../../../logic/goal_bloc/goal_bloc.dart';
import '../../../../logic/goal_bloc/goal_event.dart';

class BudgetLimitCard extends StatelessWidget {
  const BudgetLimitCard({super.key, required this.limit, required this.spent}) : isAddMode = false;

  const BudgetLimitCard.addMode({super.key})
      : limit = null,
        spent = 0,
        isAddMode = true;

  final BudgetLimitModel? limit;
  final double spent;
  final bool isAddMode;

  @override
  Widget build(BuildContext context) {
    if (isAddMode) {
      return _AddBudgetLimitSheet();
    }
    final category = Categories.byKey(limit!.category);
    final progress = limit!.limitAmount == 0 ? 0.0 : spent / limit!.limitAmount;
    final over = progress >= 1;
    final barColor = progress >= 1
        ? Colors.red
        : progress >= 0.8
            ? Colors.orange
            : const Color(0xFF1D9E75);
    return Dismissible(
      key: ValueKey(limit!.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        color: Colors.red.withOpacity(0.2),
        child: const Icon(Icons.delete, color: Colors.red),
      ),
      onDismissed: (_) => context.read<GoalBloc>().add(DeleteBudgetLimit(limit!.id)),
      child: Card(
        elevation: 0,
        color: over ? Colors.red.withOpacity(0.1) : null,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(category?.icon ?? Icons.category, color: category?.color),
                  const SizedBox(width: 8),
                  Text(category?.label ?? limit!.category, style: Theme.of(context).textTheme.titleMedium),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'Spent ${CurrencyFormatter.format(spent)} of ${CurrencyFormatter.format(limit!.limitAmount)}',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 8),
              LinearProgressIndicator(
                value: progress.isNaN ? 0.0 : progress.clamp(0.0, 1.0).toDouble(),
                minHeight: 6,
                backgroundColor: Theme.of(context).dividerColor,
                color: barColor,
              ),
              if (over) ...[
                const SizedBox(height: 6),
                Text(
                  'Over budget by ${CurrencyFormatter.format(spent - limit!.limitAmount)}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.red),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _AddBudgetLimitSheet extends StatefulWidget {
  @override
  State<_AddBudgetLimitSheet> createState() => _AddBudgetLimitSheetState();
}

class _AddBudgetLimitSheetState extends State<_AddBudgetLimitSheet> {
  String? _category;
  final TextEditingController _amountController = TextEditingController();

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Add budget limit', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: Categories.all
                .map(
                  (cat) => ChoiceChip(
                    label: Text(cat.label),
                    selected: _category == cat.key,
                    onSelected: (_) => setState(() => _category = cat.key),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _amountController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(prefixText: '₹ ', hintText: 'Limit amount'),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: () {
                final amount = double.tryParse(_amountController.text) ?? 0;
                if (_category != null && amount > 0) {
                  context.read<GoalBloc>().add(UpsertBudgetLimit(_category!, amount));
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Save limit'),
            ),
          ),
        ],
      ),
    );
  }
}