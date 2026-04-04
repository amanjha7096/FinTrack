import 'package:equatable/equatable.dart';

import '../../data/models/transaction_model.dart';
import 'transaction_state.dart';

abstract class TransactionEvent extends Equatable {
  const TransactionEvent();

  @override
  List<Object?> get props => [];
}

class LoadTransactions extends TransactionEvent {
  const LoadTransactions();
}

class AddTransaction extends TransactionEvent {
  const AddTransaction(this.transaction);

  final TransactionModel transaction;

  @override
  List<Object?> get props => [transaction];
}

class UpdateTransaction extends TransactionEvent {
  const UpdateTransaction(this.transaction);

  final TransactionModel transaction;

  @override
  List<Object?> get props => [transaction];
}

class DeleteTransaction extends TransactionEvent {
  const DeleteTransaction(this.id);

  final int id;

  @override
  List<Object?> get props => [id];
}

class FilterTransactions extends TransactionEvent {
  const FilterTransactions(this.params);

  final FilterParams params;

  @override
  List<Object?> get props => [params];
}

class ClearFilter extends TransactionEvent {
  const ClearFilter();
}

class SeedTransactions extends TransactionEvent {
  const SeedTransactions(this.seedData);

  final List<TransactionModel> seedData;

  @override
  List<Object?> get props => [seedData];
}