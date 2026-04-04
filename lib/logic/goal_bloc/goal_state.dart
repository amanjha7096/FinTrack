import 'package:equatable/equatable.dart';

import '../../data/models/budget_limit_model.dart';
import '../../data/models/goal_settings_model.dart';

abstract class GoalState extends Equatable {
  const GoalState();

  @override
  List<Object?> get props => [];
}

class GoalInitial extends GoalState {
  const GoalInitial();
}

class GoalLoading extends GoalState {
  const GoalLoading();
}

class GoalLoaded extends GoalState {
  const GoalLoaded({
    required this.settings,
    required this.budgetLimits,
    required this.spentByCategory,
    required this.dailyExpenseTotals,
    required this.currentStreak,
    required this.longestStreak,
    required this.noSpendDays,
    required this.savedThisMonth,
    required this.goalProgress,
  });

  final GoalSettingsModel settings;
  final List<BudgetLimitModel> budgetLimits;
  final Map<String, double> spentByCategory;
  final Map<DateTime, double> dailyExpenseTotals;
  final int currentStreak;
  final int longestStreak;
  final List<DateTime> noSpendDays;
  final double savedThisMonth;
  final double goalProgress;

  @override
  List<Object?> get props => [
        settings,
        budgetLimits,
        spentByCategory,
        dailyExpenseTotals,
        currentStreak,
        longestStreak,
        noSpendDays,
        savedThisMonth,
        goalProgress,
      ];
}

class GoalError extends GoalState {
  const GoalError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}