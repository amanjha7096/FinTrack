import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/theme/theme_cubit.dart';
import '../../../logic/goal_bloc/goal_bloc.dart';
import '../../../logic/goal_bloc/goal_state.dart';
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

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  AnimationController? _controller;
  bool _didStartAnimation = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _controller ??= AnimationController(
      vsync: this,
      duration: MediaQuery.of(context).disableAnimations
          ? Duration.zero
          : const Duration(milliseconds: 800),
    );
    if (!_didStartAnimation) {
      _didStartAnimation = true;
      _controller!.forward();
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  String _greeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning';
    if (hour < 17) return 'Good afternoon';
    return 'Good evening';
  }

  Widget _animatedSection({
    required double begin,
    required double end,
    required Widget child,
  }) {
    final controller = _controller;
    if (controller == null) return child;
    return FadeTransition(
      opacity: CurvedAnimation(
        parent: controller,
        curve: Interval(begin, end, curve: Curves.easeOutCubic),
      ),
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 0.08),
          end: Offset.zero,
        ).animate(
          CurvedAnimation(
            parent: controller,
            curve: Interval(begin, end, curve: Curves.easeOutCubic),
          ),
        ),
        child: child,
      ),
    );
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
              return const EmptyStateView(
                title: 'Your financial story starts here.',
                subtitle: 'Add your first transaction to begin tracking.',
                icon: Icons.account_balance_wallet_outlined,
                animated: true,
                variant: EmptyStateVariant.home,
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
          LoadingShimmer(height: 208, radius: 24),
          SizedBox(height: 16),
          LoadingShimmer(height: 96, radius: 20),
          SizedBox(height: 16),
          LoadingShimmer(height: 220, radius: 20),
          SizedBox(height: 16),
          LoadingShimmer(height: 220, radius: 20),
          SizedBox(height: 16),
          LoadingShimmer(height: 180, radius: 20),
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
          const SizedBox(height: 18),
          _animatedSection(
            begin: 0.0,
            end: 0.6,
            child: BalanceHeroCard(
              balance: state.balance,
              income: monthlyIncome,
              expense: monthlyExpense,
            ),
          ),
          const SizedBox(height: 16),
          _animatedSection(
            begin: 0.2,
            end: 0.8,
            child: SpendingDonut(transactions: currentMonthTransactions),
          ),
          const SizedBox(height: 16),
          _animatedSection(
            begin: 0.24,
            end: 0.84,
            child: WeeklyBarChart(transactions: state.transactions),
          ),
          const SizedBox(height: 16),
          _animatedSection(
            begin: 0.28,
            end: 0.88,
            child: BlocBuilder<GoalBloc, GoalState>(
              builder: (context, goalState) {
                if (goalState is GoalLoaded && goalState.settings.isGoalActive) {
                  return GoalProgressPill(goalState: goalState);
                }
                return const SizedBox.shrink();
              },
            ),
          ),
          const SizedBox(height: 16),
          _animatedSection(
            begin: 0.32,
            end: 0.92,
            child: RecentTransactionsList(transactions: state.recentThree),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final date = DateFormat('EEE, d MMM').format(DateTime.now());
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _greeting(),
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 4),
            Text(
              date,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: isDark ? AppColors.darkTextSub : AppColors.lightTextSub,
                  ),
            ),
          ],
        ),
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: Theme.of(context).dividerColor),
          ),
          child: IconButton(
            onPressed: () => context.read<ThemeCubit>().toggleTheme(),
            icon: Icon(isDark ? Icons.light_mode_outlined : Icons.dark_mode_outlined),
          ),
        ),
      ],
    );
  }
}
