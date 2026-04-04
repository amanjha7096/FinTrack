import 'package:uuid/uuid.dart';

import '../../data/models/transaction_model.dart';

class SeedData {
  SeedData._();

  static final List<TransactionModel> all = _buildSeedData();

  static List<TransactionModel> _buildSeedData() {
    final now = DateTime.now();
    final uuid = const Uuid();

    TransactionModel buildTx({
      required int daysAgo,
      required double amount,
      required String type,
      required String category,
      String? note,
    }) {
      final date = DateTime.now().subtract(Duration(days: daysAgo));
      final tx = TransactionModel();
      tx.uuid = uuid.v4();
      tx.amount = amount;
      tx.type = type;
      tx.category = category;
      tx.date = DateTime(date.year, date.month, date.day);
      tx.note = note;
      tx.createdAt = now;
      tx.updatedAt = now;
      tx.isSeeded = true;
      return tx;
    }

    return [
      buildTx(daysAgo: 30, amount: 45000, type: 'income', category: 'salary'),
      buildTx(daysAgo: 29, amount: 9000, type: 'expense', category: 'home'),
      buildTx(daysAgo: 28, amount: 850, type: 'expense', category: 'food'),
      buildTx(daysAgo: 27, amount: 320, type: 'expense', category: 'transport'),
      buildTx(daysAgo: 26, amount: 2400, type: 'expense', category: 'shopping'),
      buildTx(daysAgo: 25, amount: 650, type: 'expense', category: 'food'),
      buildTx(daysAgo: 24, amount: 1200, type: 'expense', category: 'utilities'),
      buildTx(daysAgo: 22, amount: 500, type: 'expense', category: 'entertainment'),
      buildTx(daysAgo: 21, amount: 1800, type: 'expense', category: 'health'),
      buildTx(daysAgo: 20, amount: 720, type: 'expense', category: 'food'),
      buildTx(daysAgo: 18, amount: 3000, type: 'expense', category: 'education'),
      buildTx(daysAgo: 17, amount: 450, type: 'expense', category: 'transport'),
      buildTx(daysAgo: 16, amount: 1100, type: 'expense', category: 'shopping'),
      buildTx(daysAgo: 15, amount: 8000, type: 'income', category: 'other_income'),
      buildTx(daysAgo: 14, amount: 950, type: 'expense', category: 'personal'),
      buildTx(daysAgo: 13, amount: 5000, type: 'income', category: 'salary'),
      buildTx(daysAgo: 13, amount: 1400, type: 'expense', category: 'utilities'),
      buildTx(daysAgo: 13, amount: 750, type: 'expense', category: 'food'),
      buildTx(daysAgo: 11, amount: 1800, type: 'expense', category: 'entertainment'),
      buildTx(daysAgo: 11, amount: 750, type: 'expense', category: 'utilities'),
      buildTx(daysAgo: 10, amount: 2500, type: 'income', category: 'other_income'),
      buildTx(daysAgo: 10, amount: 900, type: 'expense', category: 'food'),
      buildTx(daysAgo: 10, amount: 300, type: 'expense', category: 'transport'),
      buildTx(daysAgo: 10, amount: 6000, type: 'expense', category: 'shopping'),
      buildTx(daysAgo: 8, amount: 600, type: 'expense', category: 'health'),
      buildTx(daysAgo: 8, amount: 400, type: 'expense', category: 'personal'),
      buildTx(daysAgo: 7, amount: 4500, type: 'income', category: 'salary'),
      buildTx(daysAgo: 7, amount: 600, type: 'expense', category: 'entertainment'),
      buildTx(daysAgo: 7, amount: 1200, type: 'expense', category: 'shopping'),
      buildTx(daysAgo: 7, amount: 2200, type: 'expense', category: 'travel'),
      buildTx(daysAgo: 5, amount: 3200, type: 'income', category: 'other_income'),
      buildTx(daysAgo: 5, amount: 500, type: 'expense', category: 'transport'),
      buildTx(daysAgo: 5, amount: 2200, type: 'expense', category: 'utilities'),
      buildTx(daysAgo: 5, amount: 500, type: 'expense', category: 'food'),
      buildTx(daysAgo: 4, amount: 1200, type: 'expense', category: 'education'),
      buildTx(daysAgo: 4, amount: 700, type: 'expense', category: 'personal'),
      buildTx(daysAgo: 4, amount: 900, type: 'expense', category: 'entertainment'),
      buildTx(daysAgo: 3, amount: 4000, type: 'income', category: 'salary'),
      buildTx(daysAgo: 3, amount: 9000, type: 'expense', category: 'travel'),
      buildTx(daysAgo: 3, amount: 600, type: 'expense', category: 'food'),
      buildTx(daysAgo: 1, amount: 2800, type: 'income', category: 'other_income'),
      buildTx(daysAgo: 1, amount: 1800, type: 'expense', category: 'shopping'),
      buildTx(daysAgo: 1, amount: 900, type: 'expense', category: 'utilities'),
      buildTx(daysAgo: 1, amount: 1100, type: 'expense', category: 'health'),
      buildTx(daysAgo: 1, amount: 450, type: 'expense', category: 'food'),
    ];
  }
}