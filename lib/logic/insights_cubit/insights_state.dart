import 'package:equatable/equatable.dart';

class DailyTotal {
  DailyTotal({
    required this.date,
    required this.income,
    required this.expense,
  });

  final DateTime date;
  final double income;
  final double expense;
}

class InsightsState extends Equatable {
  const InsightsState({
    required this.selectedMonth,
    required this.expenseByCategory,
    required this.thisWeekTotal,
    required this.lastWeekTotal,
    required this.weekChangePercent,
    required this.dailyTotals,
    required this.topCategory,
    required this.avgDailySpend,
    required this.bestWeekLabel,
    required this.bestWeekSaved,
    required this.smartTip,
    required this.isLoading,
  });

  final DateTime selectedMonth;
  final Map<String, double> expenseByCategory;
  final double thisWeekTotal;
  final double lastWeekTotal;
  final double weekChangePercent;
  final List<DailyTotal> dailyTotals;
  final String topCategory;
  final double avgDailySpend;
  final String bestWeekLabel;
  final double bestWeekSaved;
  final String smartTip;
  final bool isLoading;

  factory InsightsState.initial() => InsightsState(
        selectedMonth: DateTime.now(),
        expenseByCategory: const {},
        thisWeekTotal: 0,
        lastWeekTotal: 0,
        weekChangePercent: 0,
        dailyTotals: const [],
        topCategory: '',
        avgDailySpend: 0,
        bestWeekLabel: '',
        bestWeekSaved: 0,
        smartTip: '',
        isLoading: true,
      );

  InsightsState copyWith({
    DateTime? selectedMonth,
    Map<String, double>? expenseByCategory,
    double? thisWeekTotal,
    double? lastWeekTotal,
    double? weekChangePercent,
    List<DailyTotal>? dailyTotals,
    String? topCategory,
    double? avgDailySpend,
    String? bestWeekLabel,
    double? bestWeekSaved,
    String? smartTip,
    bool? isLoading,
  }) {
    return InsightsState(
      selectedMonth: selectedMonth ?? this.selectedMonth,
      expenseByCategory: expenseByCategory ?? this.expenseByCategory,
      thisWeekTotal: thisWeekTotal ?? this.thisWeekTotal,
      lastWeekTotal: lastWeekTotal ?? this.lastWeekTotal,
      weekChangePercent: weekChangePercent ?? this.weekChangePercent,
      dailyTotals: dailyTotals ?? this.dailyTotals,
      topCategory: topCategory ?? this.topCategory,
      avgDailySpend: avgDailySpend ?? this.avgDailySpend,
      bestWeekLabel: bestWeekLabel ?? this.bestWeekLabel,
      bestWeekSaved: bestWeekSaved ?? this.bestWeekSaved,
      smartTip: smartTip ?? this.smartTip,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object?> get props => [
        selectedMonth,
        expenseByCategory,
        thisWeekTotal,
        lastWeekTotal,
        weekChangePercent,
        dailyTotals,
        topCategory,
        avgDailySpend,
        bestWeekLabel,
        bestWeekSaved,
        smartTip,
        isLoading,
      ];
}