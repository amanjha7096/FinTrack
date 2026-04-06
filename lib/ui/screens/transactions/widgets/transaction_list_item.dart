import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/categories.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../data/models/transaction_model.dart';
import '../../../../logic/transaction_bloc/transaction_bloc.dart';
import '../../../../logic/transaction_bloc/transaction_event.dart';
import '../../../shared/widgets/confirmation_dialog.dart';
import 'add_edit_transaction_sheet.dart';

class TransactionListItem extends StatefulWidget {
  const TransactionListItem({
    super.key,
    required this.transaction,
  });

  final TransactionModel transaction;

  @override
  State<TransactionListItem> createState() => _TransactionListItemState();
}

class _TransactionListItemState extends State<TransactionListItem> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final transaction = widget.transaction;
    final category = Categories.byKey(transaction.category);
    final amount = CurrencyFormatter.format(transaction.amount);
    final isIncome = transaction.type == 'income';
    final amountColor = isIncome ? AppColors.income : AppColors.expense;
    final dateLabel = DateFormat('d MMM').format(transaction.date);
    final reduced = MediaQuery.of(context).disableAnimations;

    return Dismissible(
      key: ValueKey(transaction.id),
      background: _buildSwipeAction(
        context,
        Icons.edit_rounded,
        [AppColors.gradientTealStart, AppColors.gradientTealEnd],
        Alignment.centerLeft,
      ),
      secondaryBackground: _buildSwipeAction(
        context,
        Icons.delete_rounded,
        [AppColors.healthDanger.first, AppColors.healthDanger.last],
        Alignment.centerRight,
      ),
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.startToEnd) {
          final bloc = context.read<TransactionBloc>();
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            useSafeArea: true,
            backgroundColor: Colors.transparent,
            barrierColor: AppColors.ink.withValues(alpha: 0.6),
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
          final confirmed = await showDialog<bool>(
                context: context,
                builder: (context) => const ConfirmationDialog(
                  title: 'Delete transaction',
                  message: 'Are you sure you want to delete this transaction?',
                  confirmLabel: 'Delete',
                  confirmColor: AppColors.expense,
                ),
              ) ??
              false;
          if (confirmed) {
            HapticFeedback.heavyImpact();
          }
          return confirmed;
        }
        return false;
      },
      onDismissed: (direction) {
        if (direction == DismissDirection.endToStart) {
          HapticFeedback.heavyImpact();
          context.read<TransactionBloc>().add(DeleteTransaction(transaction.id));
        }
      },
      child: GestureDetector(
        onTapDown: (_) => setState(() => _pressed = true),
        onTapUp: (_) => setState(() => _pressed = false),
        onTapCancel: () => setState(() => _pressed = false),
        onTap: () => _showDetailsSheet(context, transaction),
        onLongPress: () async {
          final confirmed = await showDialog<bool>(
                context: context,
                builder: (context) => const ConfirmationDialog(
                  title: 'Delete transaction',
                  message: 'Are you sure you want to delete this transaction?',
                  confirmLabel: 'Delete',
                  confirmColor: AppColors.expense,
                ),
              ) ??
              false;
          if (confirmed) {
            HapticFeedback.heavyImpact();
            context.read<TransactionBloc>().add(DeleteTransaction(transaction.id));
          }
        },
        child: AnimatedScale(
          scale: _pressed ? 0.97 : 1.0,
          duration: reduced ? Duration.zero : const Duration(milliseconds: 100),
          curve: Curves.easeOut,
          child: Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: Theme.of(context).dividerColor),
            ),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: category?.color ?? amountColor,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    category?.icon ?? Icons.category_rounded,
                    size: 20,
                    color: AppColors.softIvory,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        category?.label ?? transaction.category,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        (transaction.note?.isNotEmpty ?? false) ? transaction.note! : 'No note',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '${isIncome ? '+' : '-'}$amount',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: amountColor,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      dateLabel,
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: Theme.of(context).brightness == Brightness.dark
                                ? AppColors.darkTextSub
                                : AppColors.lightTextSub,
                          ),
                    ),
                  ],
                ),
              ],
            ),
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
      backgroundColor: Colors.transparent,
      barrierColor: AppColors.ink.withValues(alpha: 0.6),
      builder: (context) => _TransactionDetailsSheet(transaction: transaction),
    );
  }

  Widget _buildSwipeAction(
    BuildContext context,
    IconData icon,
    List<Color> colors,
    Alignment alignment,
  ) {
    return Container(
      alignment: alignment,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: alignment == Alignment.centerLeft ? Alignment.centerLeft : Alignment.centerRight,
          end: alignment == Alignment.centerLeft ? Alignment.centerRight : Alignment.centerLeft,
          colors: colors,
        ),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Icon(icon, color: AppColors.softIvory),
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
    final amountColor = isIncome ? AppColors.income : AppColors.expense;
    final dateLabel = DateFormat('EEEE, d MMM yyyy').format(transaction.date);
    final timeLabel = DateFormat('hh:mm a').format(transaction.date);

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: Padding(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 12,
          bottom: MediaQuery.of(context).viewInsets.bottom + 20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
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
            const SizedBox(height: 16),
            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: category?.color ?? amountColor,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    category?.icon ?? Icons.category_rounded,
                    color: AppColors.softIvory,
                  ),
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
                    color: Theme.of(context).dividerColor.withValues(alpha: 0.3),
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
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: amountColor,
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.dark
                    ? AppColors.darkCardAlt
                    : AppColors.lightCardAlt,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: Theme.of(context).dividerColor),
              ),
              child: Column(
                children: [
                  _DetailRow(label: 'Category', value: category?.label ?? transaction.category),
                  _DetailRow(label: 'Date', value: dateLabel),
                  _DetailRow(label: 'Time', value: timeLabel),
                  _DetailRow(label: 'Type', value: isIncome ? 'Income' : 'Expense'),
                ],
              ),
            ),
            if ((transaction.note ?? '').isNotEmpty) ...[
              const SizedBox(height: 14),
              Text('Note', style: Theme.of(context).textTheme.labelLarge),
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? AppColors.darkCardAlt
                      : AppColors.lightCardAlt,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: Theme.of(context).dividerColor),
                ),
                child: Text(transaction.note!, style: Theme.of(context).textTheme.bodyMedium),
              ),
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
                        backgroundColor: Colors.transparent,
                        barrierColor: AppColors.ink.withValues(alpha: 0.6),
                        builder: (context) {
                          return BlocProvider.value(
                            value: bloc,
                            child: AddEditTransactionSheet(transaction: transaction),
                          );
                        },
                      );
                    },
                    icon: const Icon(Icons.edit_rounded, size: 18),
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
                              confirmColor: AppColors.expense,
                            ),
                          ) ??
                          false;
                      if (!confirmed) return;
                      HapticFeedback.heavyImpact();
                      if (!context.mounted) return;
                      context.read<TransactionBloc>().add(DeleteTransaction(transaction.id));
                      Navigator.of(context).pop();
                    },
                    icon: const Icon(Icons.delete_rounded, size: 18, color: AppColors.expense),
                    label: const Text(
                      'Delete',
                      style: TextStyle(color: AppColors.expense),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AppColors.expense),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
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
