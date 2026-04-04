import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../data/models/transaction_model.dart';
import '../../../shared/widgets/amount_badge.dart';
import '../../../../core/constants/categories.dart';

class RecentTransactionsList extends StatelessWidget {
  const RecentTransactionsList({
    super.key,
    required this.transactions,
  });

  final List<TransactionModel> transactions;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Recent', style: Theme.of(context).textTheme.titleMedium),
            TextButton(
              onPressed: () => context.go('/transactions'),
              child: const Text('See all'),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ...transactions.map((tx) => _RecentItem(transaction: tx)),
      ],
    );
  }
}

class _RecentItem extends StatelessWidget {
  const _RecentItem({required this.transaction});

  final TransactionModel transaction;

  @override
  Widget build(BuildContext context) {
    final category = Categories.byKey(transaction.category);
    return Container(
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
              color: (category?.color ?? Theme.of(context).colorScheme.primary).withOpacity(0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(category?.icon ?? Icons.category, size: 16, color: category?.color),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(category?.label ?? transaction.category, style: Theme.of(context).textTheme.bodyMedium),
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
          AmountBadge(amount: transaction.amount, type: transaction.type),
        ],
      ),
    );
  }
}