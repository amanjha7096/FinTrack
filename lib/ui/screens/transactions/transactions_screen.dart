import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../core/constants/app_colors.dart';
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
            crossAxisAlignment: CrossAxisAlignment.start,
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
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
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
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Theme.of(context).dividerColor),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.tune_rounded),
                      onPressed: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          useSafeArea: true,
                          backgroundColor: Colors.transparent,
                          barrierColor: AppColors.ink.withValues(alpha: 0.6),
                          builder: (context) {
                            return BlocProvider.value(
                              value: context.read<TransactionBloc>(),
                              child: FilterBottomSheet(initialFilter: state.activeFilter),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Expanded(
              child: sortedKeys.isEmpty
                  ? EmptyStateView(
                      title: state.transactions.isEmpty
                          ? 'No transactions yet.'
                          : 'No transactions found',
                      subtitle: state.transactions.isEmpty
                          ? 'Tap the + button to record your first income or expense.'
                          : 'Try adjusting filters or add a new transaction.',
                      variant: EmptyStateVariant.transactions,
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
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Row(
                            children: [
                              Text(
                                _formatDate(date),
                                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                      letterSpacing: 0.8,
                                      color: Theme.of(context).brightness == Brightness.dark
                                          ? AppColors.darkTextSub
                                          : AppColors.lightTextSub,
                                    ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Container(
                                  height: 1,
                                  color: Theme.of(context).dividerColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                        ...items.map((tx) => TransactionListItem(transaction: tx)),
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
    return DateFormat('EEE d MMM').format(date);
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
    final reduced = MediaQuery.of(context).disableAnimations;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: AnimatedContainer(
        duration: reduced ? Duration.zero : const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          gradient: isSelected
              ? const LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [AppColors.gradientTealStart, AppColors.gradientTealEnd],
                )
              : null,
          color: isSelected ? null : Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? Colors.transparent : Theme.of(context).dividerColor,
          ),
        ),
        child: Text(
          label,
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: isSelected ? AppColors.softIvory : null,
              ),
        ),
      ),
    );
  }
}
