import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../core/utils/date_helpers.dart';
import '../../data/repositories/i_goal_repository.dart';
import '../../data/repositories/i_transaction_repository.dart';
import 'insights_state.dart';

@injectable
class InsightsCubit extends Cubit<InsightsState> {
  InsightsCubit(this._transactionRepository, this._goalRepository)
      : super(InsightsState.initial());

  final ITransactionRepository _transactionRepository;
  final IGoalRepository _goalRepository;

  Future<void> loadInsights(DateTime month) async {
    emit(state.copyWith(isLoading: true, selectedMonth: month));
    try {
      final startOfMonth = DateHelpers.startOfMonth(month);
      final endOfMonth = DateHelpers.endOfMonth(month);
      final expenseByCategory =
          await _transactionRepository.sumByCategory('expense', startOfMonth, endOfMonth);
      final dailyTotals = await _buildDailyTotals(startOfMonth, endOfMonth);
      final weekTotals = await _calculateWeekTotals();
      final topCategory = _findTopCategory(expenseByCategory);
      final monthTotalExpense =
          expenseByCategory.values.fold<double>(0.0, (sum, value) => sum + value);
      final now = DateTime.now();
      final isCurrentMonth = now.year == month.year && now.month == month.month;
      final daysElapsed = isCurrentMonth
          ? now.day.clamp(1, endOfMonth.day).toInt()
          : endOfMonth.day;
      final avgDailySpend = daysElapsed > 0 ? monthTotalExpense / daysElapsed : 0.0;
      final smartTip = await _buildSmartTip(
        weekTotals: weekTotals,
        expenseByCategory: expenseByCategory,
        topCategory: topCategory,
        monthTotalExpense: monthTotalExpense,
        avgDailySpend: avgDailySpend,
      );

      emit(state.copyWith(
        selectedMonth: month,
        expenseByCategory: expenseByCategory,
        dailyTotals: dailyTotals,
        thisWeekTotal: weekTotals.thisWeekTotal,
        lastWeekTotal: weekTotals.lastWeekTotal,
        weekChangePercent: weekTotals.weekChangePercent,
        topCategory: topCategory,
        avgDailySpend: avgDailySpend,
        smartTip: smartTip,
        isLoading: false,
      ));
    } catch (_) {
      emit(state.copyWith(isLoading: false));
    }
  }

  Future<List<DailyTotal>> _buildDailyTotals(DateTime start, DateTime end) async {
    final days = DateHelpers.daysInMonth(start);
    final incomeTotals =
        await _transactionRepository.getByDateRange(start, end).then((records) => records);

    final totalsByDate = <DateTime, DailyTotal>{};
    for (final day in days) {
      totalsByDate[day] = DailyTotal(date: day, income: 0, expense: 0);
    }

    for (final tx in incomeTotals) {
      final key = DateHelpers.normalizeDate(tx.date);
      final current = totalsByDate[key];
      if (current == null) continue;
      if (tx.type == 'income') {
        totalsByDate[key] = DailyTotal(
          date: current.date,
          income: current.income + tx.amount,
          expense: current.expense,
        );
      } else {
        totalsByDate[key] = DailyTotal(
          date: current.date,
          income: current.income,
          expense: current.expense + tx.amount,
        );
      }
    }

    return totalsByDate.values.toList()..sort((a, b) => a.date.compareTo(b.date));
  }

  Future<_WeekTotals> _calculateWeekTotals() async {
    final today = DateHelpers.normalizeDate(DateTime.now());
    final thisWeekStart = today.subtract(Duration(days: today.weekday - 1));
    final lastWeekStart = thisWeekStart.subtract(const Duration(days: 7));
    final lastWeekEnd = thisWeekStart.subtract(const Duration(days: 1));

    final thisWeekTotal =
        await _transactionRepository.totalByType('expense', thisWeekStart, today);
    final lastWeekTotal =
        await _transactionRepository.totalByType('expense', lastWeekStart, lastWeekEnd);
    final weekChangePercent = lastWeekTotal == 0
        ? 0.0
        : ((thisWeekTotal - lastWeekTotal) / lastWeekTotal * 100).toDouble();

    return _WeekTotals(
      thisWeekTotal: thisWeekTotal,
      lastWeekTotal: lastWeekTotal,
      weekChangePercent: weekChangePercent,
    );
  }

  String _findTopCategory(Map<String, double> expenseByCategory) {
    if (expenseByCategory.isEmpty) {
      return '';
    }
    final sorted = expenseByCategory.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    return sorted.first.key;
  }

  Future<String> _buildSmartTip({
    required _WeekTotals weekTotals,
    required Map<String, double> expenseByCategory,
    required String topCategory,
    required double monthTotalExpense,
    required double avgDailySpend,
  }) async {
    if (weekTotals.weekChangePercent > 20) {
      return 'Your spending jumped ${weekTotals.weekChangePercent.toStringAsFixed(0)}% this week vs last week. The biggest driver is $topCategory.';
    }
    if (weekTotals.weekChangePercent < -20) {
      return 'Great work! You spent ${weekTotals.weekChangePercent.abs().toStringAsFixed(0)}% less this week than last. Keep it up.';
    }
    if (monthTotalExpense > 0) {
      final foodSpend = expenseByCategory['food'] ?? 0;
      if (foodSpend / monthTotalExpense > 0.35) {
        return 'Food accounts for over 35% of your expenses this month. Consider meal planning.';
      }
    }
    final limits = await _goalRepository.getAllBudgetLimits();
    for (final limit in limits) {
      final spent = expenseByCategory[limit.category] ?? 0;
      if (spent > limit.limitAmount) {
        return 'You have exceeded your ${limit.category} budget this month.';
      }
    }
    return 'Your average daily spend this month is ₹${avgDailySpend.toStringAsFixed(0)}.';
  }
}

class _WeekTotals {
  _WeekTotals({
    required this.thisWeekTotal,
    required this.lastWeekTotal,
    required this.weekChangePercent,
  });

  final double thisWeekTotal;
  final double lastWeekTotal;
  final double weekChangePercent;
}