import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/models/transaction_model.dart';
import '../../../logic/transaction_bloc/transaction_bloc.dart';
import '../../../logic/transaction_bloc/transaction_event.dart';
import '../../../logic/transaction_bloc/transaction_state.dart';
import '../../shared/widgets/empty_state_view.dart';
import '../../shared/widgets/error_view.dart';
import 'widgets/filter_bottom_sheet.dart';
import 'widgets/transaction_list_item.dart';

class TransactionsScreen extends StatefulWidget {
  const TransactionsScreen({super.key});

  @override
  State<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      final current = context.read<TransactionBloc>().state;
      if (current is TransactionLoaded) {
        final params = current.activeFilter.copyWith(searchQuery: query);
        context.read<TransactionBloc>().add(FilterTransactions(params));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocListener<TransactionBloc, TransactionState>(
        listener: (context, state) {
          if (state is TransactionError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Theme.of(context).colorScheme.error,
                duration: const Duration(seconds: 4),
                action: SnackBarAction(label: 'Dismiss', onPressed: () {}),
              ),
            );
          }
        },
        child: BlocBuilder<TransactionBloc, TransactionState>(
          builder: (context, state) {
            if (state is TransactionLoading || state is TransactionInitial) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is TransactionError) {
              return ErrorView(
                message: state.message,
                onRetry: () => context.read<TransactionBloc>().add(const LoadTransactions()),
              );
            }
            if (state is TransactionLoaded) {
              return _buildContent(context, state);
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, TransactionLoaded state) {
    final grouped = <String, List<TransactionModel>>{};
    for (final tx in state.filtered) {
      final dateKey = DateUtils.dateOnly(tx.date).toIso8601String();
      grouped.putIfAbsent(dateKey, () => []).add(tx);
    }
    final sortedKeys = grouped.keys.toList()
      ..sort((a, b) => b.compareTo(a));

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              TextField(
                controller: _searchController,
                onChanged: _onSearchChanged,
                decoration: const InputDecoration(
                  hintText: 'Search transactions',
                  prefixIcon: Icon(Icons.search),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  _FilterChip(
                    label: 'All',
                    isSelected: state.activeFilter.type == null,
                    onTap: () {
                      _searchController.clear();
                      context.read<TransactionBloc>().add(const ClearFilter());
                    },
                  ),
                  const SizedBox(width: 8),
                  _FilterChip(
                    label: 'Income',
                    isSelected: state.activeFilter.type == 'income',
                    onTap: () {
                      context
                          .read<TransactionBloc>()
                          .add(FilterTransactions(state.activeFilter.copyWith(type: 'income')));
                    },
                  ),
                  const SizedBox(width: 8),
                  _FilterChip(
                    label: 'Expense',
                    isSelected: state.activeFilter.type == 'expense',
                    onTap: () {
                      context
                          .read<TransactionBloc>()
                          .add(FilterTransactions(state.activeFilter.copyWith(type: 'expense')));
                    },
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.filter_list),
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        useSafeArea: true,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                        ),
                        builder: (context) {
                          return BlocProvider.value(
                            value: context.read<TransactionBloc>(),
                            child: FilterBottomSheet(initialFilter: state.activeFilter),
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
        Expanded(
          child: sortedKeys.isEmpty
              ? EmptyStateView(
                  title: 'No transactions found',
                  subtitle: 'Try adjusting filters or add a new transaction.',
                )
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: sortedKeys.length,
                  itemBuilder: (context, index) {
                    final key = sortedKeys[index];
                    final date = DateTime.parse(key);
                    final items = grouped[key] ?? <TransactionModel>[];
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Text(
                            _formatDate(date),
                            style: Theme.of(context).textTheme.labelLarge,
                          ),
                        ),
                        ...items.map((tx) => TransactionListItem(transaction: tx)).toList(),
                      ],
                    );
                  },
                ),
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    final today = DateUtils.dateOnly(DateTime.now());
    final yesterday = today.subtract(const Duration(days: 1));
    if (DateUtils.isSameDay(date, today)) return 'Today';
    if (DateUtils.isSameDay(date, yesterday)) return 'Yesterday';
    return '${date.day}/${date.month}/${date.year}';
  }

}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? Theme.of(context).colorScheme.primary.withOpacity(0.12)
              : Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? Theme.of(context).colorScheme.primary : Theme.of(context).dividerColor,
          ),
        ),
        child: Text(label, style: Theme.of(context).textTheme.labelMedium),
      ),
    );
  }
}