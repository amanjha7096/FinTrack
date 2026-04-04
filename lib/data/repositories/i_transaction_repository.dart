import '../models/transaction_model.dart';

abstract class ITransactionRepository {
  Future<List<TransactionModel>> getAll();

  Future<List<TransactionModel>> getByDateRange(DateTime from, DateTime to);

  Future<List<TransactionModel>> getByType(String type);

  Future<List<TransactionModel>> getByCategory(String category);

  Future<List<TransactionModel>> search(String query);

  Future<void> add(TransactionModel tx);

  Future<void> update(TransactionModel tx);

  Future<void> deleteById(int id);

  Future<Map<String, double>> sumByCategory(String type, DateTime from, DateTime to);

  Future<double> totalByType(String type, DateTime from, DateTime to);

  Future<void> seedIfEmpty(List<TransactionModel> seedData);
}