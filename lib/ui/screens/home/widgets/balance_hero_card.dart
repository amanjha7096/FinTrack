import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';

class BalanceHeroCard extends StatefulWidget {
  const BalanceHeroCard({
    super.key,
    required this.balance,
    required this.income,
    required this.expense,
  });

  final double balance;
  final double income;
  final double expense;

  @override
  State<BalanceHeroCard> createState() => _BalanceHeroCardState();
}

class _BalanceHeroCardState extends State<BalanceHeroCard> {
  @override
  Widget build(BuildContext context) {
    final reduced = MediaQuery.of(context).disableAnimations;
    final gradient = _gradientForHealth();
    final ratio = widget.income <= 0 ? 0.0 : (widget.expense / widget.income).clamp(0.0, 1.5);
    return AnimatedContainer(
      duration: reduced ? Duration.zero : const Duration(milliseconds: 600),
      curve: Curves.easeInOut,
      height: 208,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: gradient,
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Stack(
          children: [
            Positioned(
              right: -36,
              top: -42,
              child: Container(
                width: 160,
                height: 160,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.softIvory.withValues(alpha: 0.08),
                ),
              ),
            ),
            Positioned(
              left: -26,
              bottom: -40,
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.softIvory.withValues(alpha: 0.06),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(22),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        'Total Balance',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppColors.softIvory.withValues(alpha: 0.78),
                            ),
                      ),
                      const Spacer(),
                      Text(
                        DateFormat('MMMM').format(DateTime.now()),
                        style: Theme.of(context).textTheme.labelMedium?.copyWith(
                              color: AppColors.softIvory.withValues(alpha: 0.78),
                            ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  TweenAnimationBuilder<double>(
                    tween: Tween<double>(begin: 0, end: widget.balance),
                    duration: reduced ? Duration.zero : const Duration(milliseconds: 1200),
                    curve: Curves.easeOutCubic,
                    builder: (context, value, child) {
                      return Text(
                        '\u20B9${NumberFormat('#,##,###').format(value.toInt())}',
                        style: AppTextStyles.balanceHero(context),
                      );
                    },
                  ),
                  const SizedBox(height: 8),
                  Text(
                    ratio < 0.7
                        ? 'You are saving comfortably this month'
                        : ratio < 0.9
                            ? 'You are close to break-even this month'
                            : 'Expenses are running high this month',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.softIvory.withValues(alpha: 0.78),
                        ),
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      Expanded(
                        child: _AmountChip(
                          icon: Icons.arrow_upward_rounded,
                          label: 'Income',
                          amount: widget.income,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _AmountChip(
                          icon: Icons.arrow_downward_rounded,
                          label: 'Expenses',
                          amount: widget.expense,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Color> _gradientForHealth() {
    if (widget.income <= 0) {
      return AppColors.healthGood;
    }
    final ratio = widget.expense / widget.income;
    if (ratio < 0.7) {
      return AppColors.healthGood;
    }
    if (ratio <= 0.9) {
      return AppColors.healthWarn;
    }
    return AppColors.healthDanger;
  }
}

class _AmountChip extends StatelessWidget {
  const _AmountChip({
    required this.icon,
    required this.label,
    required this.amount,
  });

  final IconData icon;
  final String label;
  final double amount;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.softIvory.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: AppColors.softIvory.withValues(alpha: 0.14),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: AppColors.softIvory.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, size: 14, color: AppColors.softIvory),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: AppColors.softIvory.withValues(alpha: 0.72),
                      ),
                ),
                const SizedBox(height: 2),
                Text(
                  '\u20B9${NumberFormat('#,##,###').format(amount.toInt())}',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: AppColors.softIvory,
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

