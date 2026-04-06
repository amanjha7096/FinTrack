import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/currency_formatter.dart';
import '../../../../logic/goal_bloc/goal_bloc.dart';
import '../../../../logic/goal_bloc/goal_event.dart';
import '../../../../logic/goal_bloc/goal_state.dart';

class SavingsGoalCard extends StatelessWidget {
  const SavingsGoalCard({super.key, required this.state});

  final GoalLoaded state;

  @override
  Widget build(BuildContext context) {
    if (!state.settings.isGoalActive) {
      return Card(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Savings goal', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 12),
              FilledButton(
                onPressed: () => _showGoalSheet(context),
                child: const Text('Set a savings goal'),
              ),
            ],
          ),
        ),
      );
    }

    final goalAmount = state.settings.savingsGoalAmount;
    final saved = state.savedThisMonth;
    final progress = (goalAmount == 0) ? 0.0 : (saved / goalAmount).clamp(0.0, 1.0).toDouble();
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Savings goal', style: Theme.of(context).textTheme.titleMedium),
                PopupMenuButton<String>(
                  onSelected: (value) {
                    if (value == 'edit') {
                      _showGoalSheet(context, amount: goalAmount);
                    } else {
                      context.read<GoalBloc>().add(const ClearSavingsGoal());
                    }
                  },
                  itemBuilder: (context) => const [
                    PopupMenuItem(value: 'edit', child: Text('Edit goal')),
                    PopupMenuItem(value: 'clear', child: Text('Clear goal')),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            Center(
              child: SizedBox(
                height: 120,
                width: 120,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    CircularProgressIndicator(
                      value: progress,
                      strokeWidth: 8,
                      color: progress >= 0.5 ? const Color(0xFF1D9E75) : const Color(0xFFE24B4A),
                    ),
                    Text('${(progress * 100).toStringAsFixed(0)}%'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Saved ${CurrencyFormatter.format(saved)} of ${CurrencyFormatter.format(goalAmount)}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }

  void _showGoalSheet(BuildContext context, {double? amount}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => _GoalSheet(initialAmount: amount),
    );
  }
}

class _GoalSheet extends StatefulWidget {
  const _GoalSheet({this.initialAmount});

  final double? initialAmount;

  @override
  State<_GoalSheet> createState() => _GoalSheetState();
}

class _GoalSheetState extends State<_GoalSheet> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.initialAmount != null) {
      _controller.text = widget.initialAmount!.toStringAsFixed(0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
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
          Text('Set savings goal', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 12),
          TextField(
            controller: _controller,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(prefixText: '₹ ', hintText: 'Goal amount'),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: () {
                final amount = double.tryParse(_controller.text) ?? 0;
                if (amount > 0) {
                  context.read<GoalBloc>().add(SetSavingsGoal(amount));
                  HapticFeedback.vibrate();
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Save goal'),
            ),
          ),
        ],
      ),
    );
  }
}