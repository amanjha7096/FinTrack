import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/categories.dart';
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
  String? _type;
  String? _category;
  DateTime? _from;
  DateTime? _to;
  SortOrder _sortOrder = SortOrder.dateDesc;

  @override
  void initState() {
    super.initState();
    _type = widget.initialFilter.type;
    _category = widget.initialFilter.category;
    _from = widget.initialFilter.from;
    _to = widget.initialFilter.to;
    _sortOrder = widget.initialFilter.sortOrder;
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      minChildSize: 0.4,
      maxChildSize: 0.9,
      expand: false,
      builder: (context, scrollController) {
        return SingleChildScrollView(
          controller: scrollController,
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Filters', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 12),
              Text('Type', style: Theme.of(context).textTheme.labelLarge),
              const SizedBox(height: 8),
              ToggleButtons(
                isSelected: [
                  _type == null,
                  _type == 'income',
                  _type == 'expense',
                ],
                onPressed: (index) {
                  setState(() {
                    if (index == 0) {
                      _type = null;
                    } else if (index == 1) {
                      _type = 'income';
                    } else {
                      _type = 'expense';
                    }
                  });
                },
                borderRadius: BorderRadius.circular(8),
                children: const [
                  Padding(padding: EdgeInsets.symmetric(horizontal: 12), child: Text('All')),
                  Padding(padding: EdgeInsets.symmetric(horizontal: 12), child: Text('Income')),
                  Padding(padding: EdgeInsets.symmetric(horizontal: 12), child: Text('Expense')),
                ],
              ),
              const SizedBox(height: 16),
              Text('Category', style: Theme.of(context).textTheme.labelLarge),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: Categories.all
                    .map(
                      (cat) => CategoryChip(
                        category: cat,
                        isSelected: _category == cat.key,
                        onTap: () => setState(() => _category = cat.key),
                      ),
                    )
                    .toList(),
              ),
              const SizedBox(height: 16),
              Text('Date range', style: Theme.of(context).textTheme.labelLarge),
              const SizedBox(height: 8),
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
                      child: Text(_from == null ? 'From' : '${_from!.day}/${_from!.month}/${_from!.year}'),
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
                      child: Text(_to == null ? 'To' : '${_to!.day}/${_to!.month}/${_to!.year}'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text('Sort', style: Theme.of(context).textTheme.labelLarge),
              const SizedBox(height: 8),
              ..._sortOptions().map(
                (option) => RadioListTile<SortOrder>(
                  value: option.order,
                  groupValue: _sortOrder,
                  onChanged: (value) => setState(() => _sortOrder = value!),
                  title: Text(option.label),
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