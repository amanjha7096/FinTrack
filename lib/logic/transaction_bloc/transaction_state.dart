import 'package:equatable/equatable.dart';

import '../../data/models/transaction_model.dart';

enum SortOrder { dateDesc, dateAsc, amountDesc, amountAsc }

class FilterParams extends Equatable {
  const FilterParams({
    this.type,
    this.category,
    this.from,
    this.to,
    this.searchQuery,
    this.sortOrder = SortOrder.dateDesc,
  });

  final String? type;
  final String? category;
  final DateTime? from;
  final DateTime? to;
  final String? searchQuery;
  final SortOrder sortOrder;

  FilterParams copyWith({
    String? type,
    String? category,
    DateTime? from,
    DateTime? to,
    String? searchQuery,
    SortOrder? sortOrder,
  }) {
    return FilterParams(
      type: type ?? this.type,
      category: category ?? this.category,
      from: from ?? this.from,
      to: to ?? this.to,
      searchQuery: searchQuery ?? this.searchQuery,
      sortOrder: sortOrder ?? this.sortOrder,
    );
  }

  static const empty = FilterParams();

  @override
  List<Object?> get props => [type, category, from, to, searchQuery, sortOrder];
}

abstract class TransactionState extends Equatable {
  const TransactionState();

  @override
  List<Object?> get props => [];
}

class TransactionInitial extends TransactionState {
  const TransactionInitial();
}

class TransactionLoading extends TransactionState {
  const TransactionLoading();
}

class TransactionLoaded extends TransactionState {
  const TransactionLoaded({
    required this.transactions,
    required this.filtered,
    required this.activeFilter,
    required this.totalIncome,
    required this.totalExpenses,
    required this.balance,
    required this.recentThree,
  });

  final List<TransactionModel> transactions;
  final List<TransactionModel> filtered;
  final FilterParams activeFilter;
  final double totalIncome;
  final double totalExpenses;
  final double balance;
  final List<TransactionModel> recentThree;

  @override
  List<Object?> get props => [
        transactions,
        filtered,
        activeFilter,
        totalIncome,
        totalExpenses,
        balance,
        recentThree,
      ];
}

class TransactionError extends TransactionState {
  const TransactionError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}