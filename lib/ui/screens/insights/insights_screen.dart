import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../logic/insights_cubit/insights_cubit.dart';
import '../../../logic/insights_cubit/insights_state.dart';
import '../../../logic/transaction_bloc/transaction_bloc.dart';
import '../../../logic/transaction_bloc/transaction_state.dart';
import '../../shared/widgets/empty_state_view.dart';
import '../../shared/widgets/loading_shimmer.dart';
import 'widgets/category_bar_chart.dart';
import 'widgets/monthly_line_chart.dart';
import 'widgets/smart_tip_card.dart';
import 'widgets/week_comparison_card.dart';

class InsightsScreen extends StatefulWidget {
  const InsightsScreen({super.key});

  @override
  State<InsightsScreen> createState() => _InsightsScreenState();
}

class _InsightsScreenState extends State<InsightsScreen> {

  @override
  void initState() {
    super.initState();
    context.read<InsightsCubit>().loadInsights(DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: MultiBlocListener(
        listeners: [
          BlocListener<TransactionBloc, TransactionState>(
            listener: (context, state) {
              if (state is TransactionLoaded) {
                context.read<InsightsCubit>().loadInsights(DateTime.now());
              }
            },
          ),
        ],
        child: BlocBuilder<InsightsCubit, InsightsState>(
          builder: (context, state) {
            if (state.isLoading) {
              return _buildLoading();
            }
            if (state.dailyTotals.isEmpty) {
              return const EmptyStateView(
                title: 'Nothing to analyse yet.',
                subtitle: 'Add a few transactions and come back.',
                icon: Icons.analytics_outlined,
                animated: true,
                variant: EmptyStateVariant.insights,
              );
            }
            return _buildContent(context, state);
          },
        ),
      ),
    );
  }

  Widget _buildLoading() {
    return const SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          LoadingShimmer(height: 80),
          SizedBox(height: 16),
          LoadingShimmer(height: 140),
          SizedBox(height: 16),
          LoadingShimmer(height: 220),
          SizedBox(height: 16),
          LoadingShimmer(height: 220),
          SizedBox(height: 16),
          LoadingShimmer(height: 90),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context, InsightsState state) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildMonthSelector(context, state),
          const SizedBox(height: 16),
          _BestWeekCard(label: state.bestWeekLabel, savedAmount: state.bestWeekSaved),
          const SizedBox(height: 16),
          WeekComparisonCard(state: state),
          const SizedBox(height: 16),
          CategoryBarChart(expenseByCategory: state.expenseByCategory),
          const SizedBox(height: 16),
          MonthlyLineChart(dailyTotals: state.dailyTotals),
          const SizedBox(height: 16),
          SmartTipCard(text: state.smartTip),
        ],
      ),
    );
  }

  Widget _buildMonthSelector(BuildContext context, InsightsState state) {
    final label = '${state.selectedMonth.month}/${state.selectedMonth.year}';
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          onPressed: () {
            final prev = DateTime(state.selectedMonth.year, state.selectedMonth.month - 1, 1);
            context.read<InsightsCubit>().loadInsights(prev);
          },
          icon: const Icon(Icons.chevron_left),
        ),
        Text(label, style: Theme.of(context).textTheme.titleMedium),
        IconButton(
          onPressed: () {
            final next = DateTime(state.selectedMonth.year, state.selectedMonth.month + 1, 1);
            context.read<InsightsCubit>().loadInsights(next);
          },
          icon: const Icon(Icons.chevron_right),
        ),
      ],
    );
  }
}

class _BestWeekCard extends StatelessWidget {
  const _BestWeekCard({required this.label, required this.savedAmount});

  final String label;
  final double savedAmount;

  @override
  Widget build(BuildContext context) {
    if (label.isEmpty) {
      return const SizedBox.shrink();
    }
    final amount = savedAmount.toStringAsFixed(0);
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.stars, color: Theme.of(context).colorScheme.primary),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Your best week was $label — you saved ₹$amount that week.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
