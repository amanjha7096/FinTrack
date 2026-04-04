import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../core/utils/date_helpers.dart';
import '../../core/utils/streak_calculator.dart';
import '../../data/models/budget_limit_model.dart';
import '../../data/repositories/i_goal_repository.dart';
import '../../data/repositories/i_transaction_repository.dart';
import 'goal_event.dart';
import 'goal_state.dart';

@injectable
class GoalBloc extends Bloc<GoalEvent, GoalState> {
  GoalBloc(this._goalRepository, this._transactionRepository) : super(const GoalInitial()) {
    on<LoadGoals>(_onLoadGoals);
    on<SetSavingsGoal>(_onSetSavingsGoal);
    on<ClearSavingsGoal>(_onClearSavingsGoal);
    on<UpsertBudgetLimit>(_onUpsertBudgetLimit);
    on<DeleteBudgetLimit>(_onDeleteBudgetLimit);
  }

  final IGoalRepository _goalRepository;
  final ITransactionRepository _transactionRepository;

  Future<void> _onLoadGoals(LoadGoals event, Emitter<GoalState> emit) async {
    emit(const GoalLoading());
    try {
      final settings = await _goalRepository.getGoalSettings();
      final limits = await _goalRepository.getAllBudgetLimits();
      final now = DateTime.now();
      final startOfMonth = DateHelpers.startOfMonth(now);
      final endOfMonth = DateHelpers.endOfMonth(now);
      final spentByCategory =
          await _transactionRepository.sumByCategory('expense', startOfMonth, endOfMonth);
      final incomeTotal = await _transactionRepository.totalByType('income', startOfMonth, endOfMonth);
      final expenseTotal =
          await _transactionRepository.totalByType('expense', startOfMonth, endOfMonth);
      final transactions = await _transactionRepository.getAll();
      final dailyExpenseTotals = <DateTime, double>{};
      for (final tx in transactions) {
        if (tx.type != 'expense') continue;
        final date = DateHelpers.normalizeDate(tx.date);
        dailyExpenseTotals[date] = (dailyExpenseTotals[date] ?? 0) + tx.amount;
      }
      final streak = computeStreak(transactions);
      final savedThisMonth = (incomeTotal - expenseTotal).toDouble();
      final goalProgress = settings.savingsGoalAmount > 0
          ? (savedThisMonth / settings.savingsGoalAmount).toDouble()
          : 0.0;

      emit(GoalLoaded(
        settings: settings,
        budgetLimits: limits,
        spentByCategory: spentByCategory,
        dailyExpenseTotals: dailyExpenseTotals,
        currentStreak: streak.currentStreak,
        longestStreak: streak.longestStreak,
        noSpendDays: streak.noSpendDays,
        savedThisMonth: savedThisMonth,
        goalProgress: goalProgress,
      ));
    } catch (error) {
      emit(GoalError(error.toString()));
    }
  }

  Future<void> _onSetSavingsGoal(SetSavingsGoal event, Emitter<GoalState> emit) async {
    emit(const GoalLoading());
    try {
      final settings = await _goalRepository.getGoalSettings();
      settings.savingsGoalAmount = event.amount;
      settings.goalStartDate = event.startDate ?? DateTime.now();
      settings.isGoalActive = true;
      await _goalRepository.saveGoalSettings(settings);
      add(const LoadGoals());
    } catch (error) {
      emit(GoalError(error.toString()));
    }
  }

  Future<void> _onClearSavingsGoal(ClearSavingsGoal event, Emitter<GoalState> emit) async {
    emit(const GoalLoading());
    try {
      final settings = await _goalRepository.getGoalSettings();
      settings.isGoalActive = false;
      settings.savingsGoalAmount = 0;
      settings.goalStartDate = null;
      await _goalRepository.saveGoalSettings(settings);
      add(const LoadGoals());
    } catch (error) {
      emit(GoalError(error.toString()));
    }
  }

  Future<void> _onUpsertBudgetLimit(UpsertBudgetLimit event, Emitter<GoalState> emit) async {
    emit(const GoalLoading());
    try {
      final limits = await _goalRepository.getAllBudgetLimits();
      final existing = limits.where((limit) => limit.category == event.category).toList();
      final limit = existing.isNotEmpty ? existing.first : BudgetLimitModel();
      limit.category = event.category;
      limit.limitAmount = event.amount;
      limit.createdAt = DateTime.now();
      await _goalRepository.upsertBudgetLimit(limit);
      add(const LoadGoals());
    } catch (error) {
      emit(GoalError(error.toString()));
    }
  }

  Future<void> _onDeleteBudgetLimit(DeleteBudgetLimit event, Emitter<GoalState> emit) async {
    emit(const GoalLoading());
    try {
      await _goalRepository.deleteBudgetLimit(event.id);
      add(const LoadGoals());
    } catch (error) {
      emit(GoalError(error.toString()));
    }
  }
}