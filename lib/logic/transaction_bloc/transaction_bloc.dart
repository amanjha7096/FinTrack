import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../core/utils/date_helpers.dart';
import '../../data/models/transaction_model.dart';
import '../../data/repositories/i_transaction_repository.dart';
import 'transaction_event.dart';
import 'transaction_state.dart';

@injectable
class TransactionBloc extends Bloc<TransactionEvent, TransactionState> {
  TransactionBloc(this._repository) : super(const TransactionInitial()) {
    on<LoadTransactions>(_onLoadTransactions);
    on<AddTransaction>(_onAddTransaction);
    on<UpdateTransaction>(_onUpdateTransaction);
    on<DeleteTransaction>(_onDeleteTransaction);
    on<FilterTransactions>(_onFilterTransactions);
    on<ClearFilter>(_onClearFilter);
    on<SeedTransactions>(_onSeedTransactions);
  }

  final ITransactionRepository _repository;

  Future<void> _onLoadTransactions(LoadTransactions event, Emitter<TransactionState> emit) async {
    emit(const TransactionLoading());
    try {
      final transactions = await _repository.getAll();
      emit(_buildLoaded(transactions, FilterParams.empty));
    } catch (error) {
      emit(TransactionError(error.toString()));
    }
  }

  Future<void> _onAddTransaction(AddTransaction event, Emitter<TransactionState> emit) async {
    emit(const TransactionLoading());
    try {
      await _repository.add(event.transaction);
      final transactions = await _repository.getAll();
      emit(_buildLoaded(transactions, FilterParams.empty));
    } catch (error) {
      emit(TransactionError(error.toString()));
    }
  }

  Future<void> _onUpdateTransaction(UpdateTransaction event, Emitter<TransactionState> emit) async {
    emit(const TransactionLoading());
    try {
      await _repository.update(event.transaction);
      final transactions = await _repository.getAll();
      emit(_buildLoaded(transactions, FilterParams.empty));
    } catch (error) {
      emit(TransactionError(error.toString()));
    }
  }

  Future<void> _onDeleteTransaction(DeleteTransaction event, Emitter<TransactionState> emit) async {
    emit(const TransactionLoading());
    try {
      await _repository.deleteById(event.id);
      final transactions = await _repository.getAll();
      emit(_buildLoaded(transactions, FilterParams.empty));
    } catch (error) {
      emit(TransactionError(error.toString()));
    }
  }

  Future<void> _onFilterTransactions(FilterTransactions event, Emitter<TransactionState> emit) async {
    final current = state;
    if (current is! TransactionLoaded) {
      return;
    }
    final filtered = _applyFilter(current.transactions, event.params);
    emit(TransactionLoaded(
      transactions: current.transactions,
      filtered: filtered,
      activeFilter: event.params,
      totalIncome: current.totalIncome,
      totalExpenses: current.totalExpenses,
      balance: current.balance,
      recentThree: current.recentThree,
    ));
  }

  Future<void> _onClearFilter(ClearFilter event, Emitter<TransactionState> emit) async {
    final current = state;
    if (current is! TransactionLoaded) {
      return;
    }
    emit(TransactionLoaded(
      transactions: current.transactions,
      filtered: current.transactions,
      activeFilter: FilterParams.empty,
      totalIncome: current.totalIncome,
      totalExpenses: current.totalExpenses,
      balance: current.balance,
      recentThree: current.recentThree,
    ));
  }

  Future<void> _onSeedTransactions(SeedTransactions event, Emitter<TransactionState> emit) async {
    emit(const TransactionLoading());
    try {
      await _repository.seedIfEmpty(event.seedData);
      final transactions = await _repository.getAll();
      emit(_buildLoaded(transactions, FilterParams.empty));
    } catch (error) {
      emit(TransactionError(error.toString()));
    }
  }

  TransactionLoaded _buildLoaded(List<TransactionModel> transactions, FilterParams filter) {
    final filtered = _applyFilter(transactions, filter);
    final totalIncome = transactions
        .where((tx) => tx.type == 'income')
        .fold<double>(0, (sum, tx) => sum + tx.amount);
    final totalExpenses = transactions
        .where((tx) => tx.type == 'expense')
        .fold<double>(0, (sum, tx) => sum + tx.amount);
    final balance = totalIncome - totalExpenses;
    final recentThree = List<TransactionModel>.from(transactions)
      ..sort((a, b) => b.date.compareTo(a.date));

    return TransactionLoaded(
      transactions: transactions,
      filtered: filtered,
      activeFilter: filter,
      totalIncome: totalIncome,
      totalExpenses: totalExpenses,
      balance: balance,
      recentThree: recentThree.take(3).toList(),
    );
  }

  List<TransactionModel> _applyFilter(List<TransactionModel> transactions, FilterParams filter) {
    var results = List<TransactionModel>.from(transactions);

    if (filter.type != null) {
      results = results.where((tx) => tx.type == filter.type).toList();
    }
    if (filter.category != null) {
      results = results.where((tx) => tx.category == filter.category).toList();
    }
    if (filter.from != null && filter.to != null) {
      final from = DateHelpers.normalizeDate(filter.from!);
      final to = DateHelpers.normalizeDate(filter.to!);
      results = results.where((tx) {
        final date = DateHelpers.normalizeDate(tx.date);
        return !date.isBefore(from) && !date.isAfter(to);
      }).toList();
    }
    if (filter.searchQuery != null && filter.searchQuery!.isNotEmpty) {
      final query = filter.searchQuery!.toLowerCase();
      results = results.where((tx) {
        final note = tx.note?.toLowerCase() ?? '';
        return note.contains(query) || tx.category.toLowerCase().contains(query);
      }).toList();
    }

    switch (filter.sortOrder) {
      case SortOrder.dateAsc:
        results.sort((a, b) => a.date.compareTo(b.date));
        break;
      case SortOrder.dateDesc:
        results.sort((a, b) => b.date.compareTo(a.date));
        break;
      case SortOrder.amountAsc:
        results.sort((a, b) => a.amount.compareTo(b.amount));
        break;
      case SortOrder.amountDesc:
        results.sort((a, b) => b.amount.compareTo(a.amount));
        break;
    }

    return results;
  }
}