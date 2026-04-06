import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/categories.dart';
import '../../../../core/di/injection.dart';
import '../../../../data/repositories/i_goal_repository.dart';
import '../../../../logic/transaction_bloc/transaction_bloc.dart';
import '../../../../logic/transaction_bloc/transaction_event.dart';
import '../../../../logic/transaction_bloc/transaction_state.dart';
import '../../../shared/widgets/category_chip.dart';

class FilterBottomSheet extends StatefulWidget {
  const FilterBottomSheet({
    super.key,
    required this.initialFilter,
  });

  final FilterParams initialFilter;

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  final IGoalRepository _goalRepository = getIt<IGoalRepository>();
  String? _type;
  String? _category;
  DateTime? _from;
  DateTime? _to;
  SortOrder _sortOrder = SortOrder.dateDesc;
  List<String> _customCategories = [];

  @override
  void initState() {
    super.initState();
    _type = widget.initialFilter.type;
    _category = widget.initialFilter.category;
    _from = widget.initialFilter.from;
    _to = widget.initialFilter.to;
    _sortOrder = widget.initialFilter.sortOrder;
    _loadCustomCategories();
  }

  Future<void> _loadCustomCategories() async {
    final settings = await _goalRepository.getAppSettings();
    if (!mounted) return;
    setState(() => _customCategories = List<String>.from(settings.customCategories));
  }

  @override
  Widget build(BuildContext context) {
    final reduced = MediaQuery.of(context).disableAnimations;
    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      minChildSize: 0.4,
      maxChildSize: 0.9,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            border: Border.all(color: Theme.of(context).dividerColor),
          ),
          child: SingleChildScrollView(
            controller: scrollController,
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Theme.of(context).dividerColor,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                Text('Filters', style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 16),
                Text('Type', style: Theme.of(context).textTheme.labelLarge),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  children: [
                    _TypeChip(
                      label: 'All',
                      selected: _type == null,
                      onTap: () => setState(() => _type = null),
                    ),
                    _TypeChip(
                      label: 'Income',
                      selected: _type == 'income',
                      onTap: () => setState(() => _type = 'income'),
                    ),
                    _TypeChip(
                      label: 'Expense',
                      selected: _type == 'expense',
                      onTap: () => setState(() => _type = 'expense'),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text('Category', style: Theme.of(context).textTheme.labelLarge),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: Categories.withCustom(_customCategories)
                      .map(
                        (cat) => CategoryChip(
                          category: cat,
                          isSelected: _category == cat.key,
                          onTap: () => setState(() => _category = _category == cat.key ? null : cat.key),
                        ),
                      )
                      .toList(),
                ),
                const SizedBox(height: 16),
                Text('Date range', style: Theme.of(context).textTheme.labelLarge),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () async {
                          final picked = await showDatePicker(
                            context: context,
                            initialDate: _from ?? DateTime.now(),
                            firstDate: DateTime(2020),
                            lastDate: DateTime.now(),
                          );
                          if (picked != null) {
                            setState(() => _from = picked);
                          }
                        },
                        child: Text(_from == null ? 'From' : DateFormat('d MMM yyyy').format(_from!)),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () async {
                          final picked = await showDatePicker(
                            context: context,
                            initialDate: _to ?? DateTime.now(),
                            firstDate: DateTime(2020),
                            lastDate: DateTime.now(),
                          );
                          if (picked != null) {
                            setState(() => _to = picked);
                          }
                        },
                        child: Text(_to == null ? 'To' : DateFormat('d MMM yyyy').format(_to!)),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text('Sort', style: Theme.of(context).textTheme.labelLarge),
                const SizedBox(height: 8),
                ..._sortOptions().map(
                  (option) => AnimatedContainer(
                    duration: reduced ? Duration.zero : const Duration(milliseconds: 200),
                    margin: const EdgeInsets.only(bottom: 8),
                    decoration: BoxDecoration(
                      color: _sortOrder == option.order
                          ? AppColors.income.withValues(alpha: 0.12)
                          : Theme.of(context).brightness == Brightness.dark
                              ? AppColors.darkCardAlt
                              : AppColors.lightCardAlt,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: _sortOrder == option.order ? AppColors.income : Theme.of(context).dividerColor,
                      ),
                    ),
                    child: RadioListTile<SortOrder>(
                      value: option.order,
                      groupValue: _sortOrder,
                      onChanged: (value) => setState(() => _sortOrder = value!),
                      title: Text(option.label),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          context.read<TransactionBloc>().add(const ClearFilter());
                          Navigator.of(context).pop();
                        },
                        child: const Text('Reset'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: FilledButton(
                        onPressed: () {
                          final params = FilterParams(
                            type: _type,
                            category: _category,
                            from: _from,
                            to: _to,
                            sortOrder: _sortOrder,
                          );
                          context.read<TransactionBloc>().add(FilterTransactions(params));
                          Navigator.of(context).pop();
                        },
                        child: const Text('Apply'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  List<_SortOption> _sortOptions() {
    return const [
      _SortOption(order: SortOrder.dateDesc, label: 'Date (newest first)'),
      _SortOption(order: SortOrder.dateAsc, label: 'Date (oldest first)'),
      _SortOption(order: SortOrder.amountDesc, label: 'Amount (high to low)'),
      _SortOption(order: SortOrder.amountAsc, label: 'Amount (low to high)'),
    ];
  }
}

class _SortOption {
  const _SortOption({required this.order, required this.label});

  final SortOrder order;
  final String label;
}

class _TypeChip extends StatelessWidget {
  const _TypeChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final reduced = MediaQuery.of(context).disableAnimations;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: AnimatedContainer(
        duration: reduced ? Duration.zero : const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          gradient: selected
              ? const LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [AppColors.gradientTealStart, AppColors.gradientTealEnd],
                )
              : null,
          color: selected ? null : Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected ? Colors.transparent : Theme.of(context).dividerColor,
          ),
        ),
        child: Text(
          label,
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: selected ? AppColors.softIvory : null,
              ),
        ),
      ),
    );
  }
}
