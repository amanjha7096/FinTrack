import 'package:equatable/equatable.dart';

abstract class GoalEvent extends Equatable {
  const GoalEvent();

  @override
  List<Object?> get props => [];
}

class LoadGoals extends GoalEvent {
  const LoadGoals();
}

class SetSavingsGoal extends GoalEvent {
  const SetSavingsGoal(this.amount, {this.startDate});

  final double amount;
  final DateTime? startDate;

  @override
  List<Object?> get props => [amount, startDate];
}

class ClearSavingsGoal extends GoalEvent {
  const ClearSavingsGoal();
}

class UpsertBudgetLimit extends GoalEvent {
  const UpsertBudgetLimit(this.category, this.amount);

  final String category;
  final double amount;

  @override
  List<Object?> get props => [category, amount];
}

class DeleteBudgetLimit extends GoalEvent {
  const DeleteBudgetLimit(this.id);

  final int id;

  @override
  List<Object?> get props => [id];
}