import 'package:flutter/material.dart';

import '../../../core/utils/currency_formatter.dart';

class AmountBadge extends StatelessWidget {
  const AmountBadge({
    super.key,
    required this.amount,
    required this.type,
  });

  final double amount;
  final String type;

  @override
  Widget build(BuildContext context) {
    final isIncome = type == 'income';
    final color = isIncome ? const Color(0xFF1D9E75) : const Color(0xFFE24B4A);
    final icon = isIncome ? Icons.arrow_upward : Icons.arrow_downward;
    final formatted = CurrencyFormatter.format(amount);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: color),
        const SizedBox(width: 4),
        Text(
          '${isIncome ? '+' : '-'}$formatted',
          style: Theme.of(context).textTheme.labelLarge?.copyWith(color: color),
        ),
      ],
    );
  }
}