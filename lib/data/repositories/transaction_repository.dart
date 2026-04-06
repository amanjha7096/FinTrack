import 'package:injectable/injectable.dart';
import 'package:isar/isar.dart';

import '../../core/constants/categories.dart';
import '../../core/utils/date_helpers.dart';
import '../models/transaction_model.dart';
import 'i_transaction_repository.dart';

@LazySingleton(as: ITransactionRepository)
class TransactionRepository implements ITransactionRepository {
  TransactionRepository(this._isar);

  final Isar _isar;

  @override
  Future<List<TransactionModel>> getAll() async {
    try {
      return await _isar.txn(() async {
        return _isar.transactionModels.where().sortByDateDesc().findAll();
      });
    } catch (error) {
      throw Exception('Failed to load transactions: $error');
    }
  }

  @override
  Future<List<TransactionModel>> getByDateRange(DateTime from, DateTime to) async {
    try {
      return await _isar.txn(() async {
        return _isar.transactionModels
            .filter()
            .dateBetween(DateHelpers.normalizeDate(from), DateHelpers.normalizeDate(to))
            .sortByDateDesc()
            .findAll();
      });
    } catch (error) {
      throw Exception('Failed to load transactions: $error');
    }
  }

  @override
  Future<List<TransactionModel>> getByType(String type) async {
    try {
      return await _isar.txn(() async {
        return _isar.transactionModels.filter().typeEqualTo(type).sortByDateDesc().findAll();
      });
    } catch (error) {
      throw Exception('Failed to load transactions: $error');
    }
  }

  @override
  Future<List<TransactionModel>> getByCategory(String category) async {
    try {
      return await _isar.txn(() async {
        return _isar.transactionModels
            .filter()
            .categoryEqualTo(category)
            .sortByDateDesc()
            .findAll();
      });
    } catch (error) {
      throw Exception('Failed to load transactions: $error');
    }
  }

  @override
  Future<List<TransactionModel>> search(String query) async {
    try {
      final lowerQuery = query.toLowerCase();
      return await _isar.txn(() async {
        return _isar.transactionModels
            .filter()
            .group((q) => q
                .noteContains(lowerQuery, caseSensitive: false)
                .or()
                .categoryContains(lowerQuery, caseSensitive: false))
            .sortByDateDesc()
            .findAll();
      });
    } catch (error) {
      throw Exception('Failed to search transactions: $error');
    }
  }

  @override
  Future<void> add(TransactionModel tx) async {
    try {
      _validateTransaction(tx);
      await _isar.writeTxn(() async {
        await _isar.transactionModels.put(tx);
      });
    } catch (error) {
      throw Exception('Failed to add transaction: $error');
    }
  }

  @override
  Future<void> update(TransactionModel tx) async {
    try {
      _validateTransaction(tx);
      await _isar.writeTxn(() async {
        await _isar.transactionModels.put(tx);
      });
    } catch (error) {
      throw Exception('Failed to update transaction: $error');
    }
  }

  @override
  Future<void> deleteById(int id) async {
    try {
      await _isar.writeTxn(() async {
        await _isar.transactionModels.delete(id);
      });
    } catch (error) {
      throw Exception('Failed to delete transaction: $error');
    }
  }

  @override
  Future<Map<String, double>> sumByCategory(String type, DateTime from, DateTime to) async {
    try {
      return await _isar.txn(() async {
        final records = await _isar.transactionModels
            .filter()
            .typeEqualTo(type)
            .dateBetween(DateHelpers.normalizeDate(from), DateHelpers.normalizeDate(to))
            .findAll();
        final Map<String, double> totals = {};
        for (final tx in records) {
          totals[tx.category] = (totals[tx.category] ?? 0) + tx.amount;
        }
        return totals;
      });
    } catch (error) {
      throw Exception('Failed to sum transactions: $error');
    }
  }

  @override
  Future<double> totalByType(String type, DateTime from, DateTime to) async {
    try {
      return await _isar.txn(() async {
        final records = await _isar.transactionModels
            .filter()
            .typeEqualTo(type)
            .dateBetween(DateHelpers.normalizeDate(from), DateHelpers.normalizeDate(to))
            .findAll();
        var total = 0.0;
        for (final tx in records) {
          total += tx.amount;
        }
        return total;
      });
    } catch (error) {
      throw Exception('Failed to total transactions: $error');
    }
  }

  @override
  Future<void> seedIfEmpty(List<TransactionModel> seedData) async {
    try {
      await _isar.writeTxn(() async {
        final existing = await _isar.transactionModels.count();
        if (existing == 0) {
          await _isar.transactionModels.putAll(seedData);
        }
      });
    } catch (error) {
      throw Exception('Failed to seed transactions: $error');
    }
  }

  void _validateTransaction(TransactionModel tx) {
    if (tx.amount <= 0) {
      throw Exception('Amount must be greater than 0');
    }
    if (tx.type != 'income' && tx.type != 'expense') {
      throw Exception('Invalid transaction type');
    }
    if (tx.category.trim().isEmpty) {
      throw Exception('Invalid transaction category');
    }
  }
}
