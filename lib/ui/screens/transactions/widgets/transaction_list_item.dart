import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/categories.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../data/models/transaction_model.dart';
import '../../../../logic/transaction_bloc/transaction_bloc.dart';
import '../../../../logic/transaction_bloc/transaction_event.dart';
import '../../../shared/widgets/confirmation_dialog.dart';
import 'add_edit_transaction_sheet.dart';

class TransactionListItem extends StatelessWidget {
  const TransactionListItem({
    super.key,
    required this.transaction,
  });

  final TransactionModel transaction;

  @override
  Widget build(BuildContext context) {
    final category = Categories.byKey(transaction.category);
    final amount = CurrencyFormatter.format(transaction.amount);
    final isIncome = transaction.type == 'income';
    final amountColor = isIncome ? const Color(0xFF1D9E75) : const Color(0xFFE24B4A);
    final dateLabel = DateFormat('d MMM').format(transaction.date);

    return Dismissible(
      key: ValueKey(transaction.id),
      background: _buildSwipeAction(context, Icons.edit, Colors.blue, Alignment.centerLeft),
      secondaryBackground: _buildSwipeAction(context, Icons.delete, Colors.red, Alignment.centerRight),
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.startToEnd) {
          final bloc = context.read<TransactionBloc>();
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            useSafeArea: true,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            builder: (context) {
              return BlocProvider.value(
                value: bloc,
                child: AddEditTransactionSheet(transaction: transaction),
              );
            },
          );
          return false;
        }
        if (direction == DismissDirection.endToStart) {
          return await showDialog<bool>(
                context: context,
                builder: (context) => const ConfirmationDialog(
                  title: 'Delete transaction',
                  message: 'Are you sure you want to delete this transaction?',
                  confirmLabel: 'Delete',
                  confirmColor: Colors.red,
                ),
              ) ??
              false;
        }
        return false;
      },
      onDismissed: (direction) {
        if (direction == DismissDirection.endToStart) {
          context.read<TransactionBloc>().add(DeleteTransaction(transaction.id));
        }
      },
      child: GestureDetector(
        onTap: () => _showDetailsSheet(context, transaction),
        onLongPress: () async {
          final confirmed = await showDialog<bool>(
                context: context,
                builder: (context) => const ConfirmationDialog(
                  title: 'Delete transaction',
                  message: 'Are you sure you want to delete this transaction?',
                  confirmLabel: 'Delete',
                  confirmColor: Colors.red,
                ),
              ) ??
              false;
          if (confirmed) {
            context.read<TransactionBloc>().add(DeleteTransaction(transaction.id));
          }
        },
        child: Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Theme.of(context).dividerColor),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: (category?.color ?? amountColor).withOpacity(0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(category?.icon ?? Icons.category, size: 16, color: category?.color),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(category?.label ?? transaction.category,
                        style: Theme.of(context).textTheme.bodyMedium),
                    if (transaction.note != null && transaction.note!.isNotEmpty)
                      Text(
                        transaction.note!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${isIncome ? '+' : '-'}$amount',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: amountColor),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: Theme.of(context).dividerColor.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      dateLabel,
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDetailsSheet(BuildContext context, TransactionModel transaction) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => _TransactionDetailsSheet(transaction: transaction),
    );
  }

  Widget _buildSwipeAction(
    BuildContext context,
    IconData icon,
    Color color,
    Alignment alignment,
  ) {
    return Container(
      alignment: alignment,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      color: color.withOpacity(0.2),
      child: Icon(icon, color: color),
    );
  }
}

class _TransactionDetailsSheet extends StatelessWidget {
  const _TransactionDetailsSheet({required this.transaction});

  final TransactionModel transaction;

  @override
  Widget build(BuildContext context) {
    final category = Categories.byKey(transaction.category);
    final amount = CurrencyFormatter.format(transaction.amount);
    final isIncome = transaction.type == 'income';
    final amountColor = isIncome ? const Color(0xFF1D9E75) : const Color(0xFFE24B4A);
    final dateLabel = DateFormat('EEEE, d MMM yyyy').format(transaction.date);

    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: (category?.color ?? amountColor).withOpacity(0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(category?.icon ?? Icons.category, color: category?.color),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      category?.label ?? transaction.category,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      dateLabel,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: Theme.of(context).dividerColor.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  isIncome ? 'Income' : 'Expense',
                  style: Theme.of(context).textTheme.labelSmall,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            '${isIncome ? '+' : '-'}$amount',
            style: Theme.of(context)
                .textTheme
                .headlineSmall
                ?.copyWith(color: amountColor, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 16),
          _DetailRow(label: 'Category', value: category?.label ?? transaction.category),
          _DetailRow(label: 'Date', value: dateLabel),
          _DetailRow(label: 'Type', value: isIncome ? 'Income' : 'Expense'),
          if ((transaction.note ?? '').isNotEmpty) ...[
            const SizedBox(height: 8),
            Text('Note', style: Theme.of(context).textTheme.labelLarge),
            const SizedBox(height: 6),
            Text(transaction.note!, style: Theme.of(context).textTheme.bodyMedium),
          ],
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    Navigator.of(context).pop();
                    final bloc = context.read<TransactionBloc>();
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      useSafeArea: true,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                      ),
                      builder: (context) {
                        return BlocProvider.value(
                          value: bloc,
                          child: AddEditTransactionSheet(transaction: transaction),
                        );
                      },
                    );
                  },
                  icon: const Icon(Icons.edit, size: 18),
                  label: const Text('Edit'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () async {
                    final confirmed = await showDialog<bool>(
                          context: context,
                          builder: (context) => const ConfirmationDialog(
                            title: 'Delete transaction',
                            message: 'Are you sure you want to delete this transaction?',
                            confirmLabel: 'Delete',
                            confirmColor: Colors.red,
                          ),
                        ) ??
                        false;
                    if (!confirmed) return;
                    context.read<TransactionBloc>().add(DeleteTransaction(transaction.id));
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(Icons.delete, size: 18, color: Colors.red),
                  label: const Text('Delete', style: TextStyle(color: Colors.red)),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.red),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          SizedBox(
            width: 90,
            child: Text(label, style: Theme.of(context).textTheme.bodySmall),
          ),
          Expanded(
            child: Text(value, style: Theme.of(context).textTheme.bodyMedium),
          ),
        ],
      ),
    );
  }
}