import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../core/constants/app_spacing.dart';
import '../../../logic/goal_bloc/goal_bloc.dart';
import '../../../logic/goal_bloc/goal_state.dart';
import '../../../core/theme/theme_cubit.dart';
import '../../../logic/transaction_bloc/transaction_bloc.dart';
import '../../../logic/transaction_bloc/transaction_event.dart';
import '../../../logic/transaction_bloc/transaction_state.dart';
import '../../shared/widgets/empty_state_view.dart';
import '../../shared/widgets/error_view.dart';
import '../../shared/widgets/loading_shimmer.dart';
import 'widgets/balance_hero_card.dart';
import 'widgets/goal_progress_pill.dart';
import 'widgets/income_expense_strip.dart';
import 'widgets/recent_transactions_list.dart';
import 'widgets/spending_donut.dart';
import 'widgets/weekly_bar_chart.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  String _greeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning';
    if (hour < 17) return 'Good afternoon';
    return 'Good evening';
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocBuilder<TransactionBloc, TransactionState>(
        builder: (context, state) {
          if (state is TransactionLoading || state is TransactionInitial) {
            return _buildLoading();
          }
          if (state is TransactionError) {
            return ErrorView(
              message: state.message,
              onRetry: () => context.read<TransactionBloc>().add(const LoadTransactions()),
            );
          }
          if (state is TransactionLoaded) {
            if (state.transactions.isEmpty) {
              return EmptyStateView(
                title: 'No transactions yet',
                subtitle: 'Add your first transaction to get started.',
                ctaLabel: 'Add transaction',
                onCta: () => context.read<TransactionBloc>().add(const LoadTransactions()),
              );
            }
            return _buildContent(context, state);
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildLoading() {
    return SingleChildScrollView(
      padding: AppSpacing.screenPadding,
      child: Column(
        children: const [
          LoadingShimmer(height: 140),
          SizedBox(height: 16),
          LoadingShimmer(height: 90),
          SizedBox(height: 16),
          LoadingShimmer(height: 220),
          SizedBox(height: 16),
          LoadingShimmer(height: 220),
          SizedBox(height: 16),
          LoadingShimmer(height: 90),
          SizedBox(height: 16),
          LoadingShimmer(height: 180),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context, TransactionLoaded state) {
    final now = DateTime.now();
    final currentMonthTransactions = state.transactions.where((tx) {
      return tx.date.year == now.year && tx.date.month == now.month;
    }).toList();
    final monthlyIncome = currentMonthTransactions
        .where((tx) => tx.type == 'income')
        .fold<double>(0, (sum, tx) => sum + tx.amount);
    final monthlyExpense = currentMonthTransactions
        .where((tx) => tx.type == 'expense')
        .fold<double>(0, (sum, tx) => sum + tx.amount);

    return SingleChildScrollView(
      padding: AppSpacing.screenPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context),
          const SizedBox(height: 16),
          BalanceHeroCard(balance: state.balance),
          const SizedBox(height: 16),
          IncomeExpenseStrip(income: monthlyIncome, expense: monthlyExpense),
          const SizedBox(height: 16),
          SpendingDonut(transactions: currentMonthTransactions),
          const SizedBox(height: 16),
          WeeklyBarChart(transactions: state.transactions),
          const SizedBox(height: 16),
          BlocBuilder<GoalBloc, GoalState>(
            builder: (context, goalState) {
              if (goalState is GoalLoaded && goalState.settings.isGoalActive) {
                return GoalProgressPill(goalState: goalState);
              }
              return const SizedBox.shrink();
            },
          ),
          const SizedBox(height: 16),
          RecentTransactionsList(transactions: state.recentThree),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final date = DateFormat('EEE, d MMM').format(DateTime.now());
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${_greeting()},',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 4),
            Text(
              date,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
        IconButton(
          onPressed: () => context.read<ThemeCubit>().toggleTheme(),
          icon: const Icon(Icons.dark_mode_outlined),
        ),
      ],
    );
  }
}