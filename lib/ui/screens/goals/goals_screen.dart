import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../logic/goal_bloc/goal_bloc.dart';
import '../../../logic/goal_bloc/goal_event.dart';
import '../../../logic/goal_bloc/goal_state.dart';
import '../../shared/widgets/empty_state_view.dart';
import '../../shared/widgets/error_view.dart';
import '../../shared/widgets/loading_shimmer.dart';
import 'widgets/budget_limit_card.dart';
import 'widgets/savings_goal_card.dart';
import 'widgets/streak_heatmap.dart';
import 'widgets/streak_milestone_banner.dart';

class GoalsScreen extends StatefulWidget {
  const GoalsScreen({super.key});

  @override
  State<GoalsScreen> createState() => _GoalsScreenState();
}

class _GoalsScreenState extends State<GoalsScreen> {
  GoalLoaded? _lastLoaded;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocListener<GoalBloc, GoalState>(
        listener: (context, state) {
          if (state is GoalError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Theme.of(context).colorScheme.error,
                duration: const Duration(seconds: 4),
                action: SnackBarAction(label: 'Dismiss', onPressed: () {}),
              ),
            );
          }
          if (state is GoalLoaded) {
            if (_lastLoaded != null) {
              if (_lastLoaded!.settings.isGoalActive != state.settings.isGoalActive ||
                  _lastLoaded!.settings.savingsGoalAmount != state.settings.savingsGoalAmount ||
                  _lastLoaded!.budgetLimits.length != state.budgetLimits.length) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('Goals updated'),
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    duration: const Duration(seconds: 2),
                  ),
                );
              }
            }
            _lastLoaded = state;
          }
        },
        child: BlocBuilder<GoalBloc, GoalState>(
          builder: (context, state) {
            if (state is GoalLoading || state is GoalInitial) {
              return _buildLoading();
            }
            if (state is GoalError) {
              return ErrorView(
                message: state.message,
                onRetry: () => context.read<GoalBloc>().add(const LoadGoals()),
              );
            }
            if (state is GoalLoaded) {
              return _buildContent(context, state);
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildLoading() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: const [
          LoadingShimmer(height: 220),
          SizedBox(height: 16),
          LoadingShimmer(height: 160),
          SizedBox(height: 16),
          LoadingShimmer(height: 120),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context, GoalLoaded state) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          StreakHeatmap(state: state),
          const SizedBox(height: 12),
          StreakMilestoneBanner(currentStreak: state.currentStreak),
          const SizedBox(height: 16),
          SavingsGoalCard(state: state),
          const SizedBox(height: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text('Budget limits', style: Theme.of(context).textTheme.titleMedium),
                  const Spacer(),
                  FilledButton.icon(
                    onPressed: () => _showAddBudgetSheet(context),
                    icon: const Icon(Icons.add, size: 18),
                    label: const Text('Add budget'),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              if (state.budgetLimits.isEmpty)
                EmptyStateView(
                  title: 'No budgets yet',
                  subtitle: 'Add a budget limit to keep spending in check.',
                  ctaLabel: 'Add budget',
                  onCta: () => _showAddBudgetSheet(context),
                )
              else
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ...state.budgetLimits.map(
                      (limit) => BudgetLimitCard(
                        limit: limit,
                        spent: state.spentByCategory[limit.category] ?? 0,
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ],
      ),
    );
  }

  void _showAddBudgetSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return BlocProvider.value(
          value: context.read<GoalBloc>(),
          child: const BudgetLimitCard.addMode(),
        );
      },
    );
  }
}