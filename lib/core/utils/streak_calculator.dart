import '../../data/models/transaction_model.dart';
import 'date_helpers.dart';

class StreakResult {
  StreakResult({
    required this.currentStreak,
    required this.longestStreak,
    required this.noSpendDays,
  });

  final int currentStreak;
  final int longestStreak;
  final List<DateTime> noSpendDays;
}

StreakResult computeStreak(List<TransactionModel> transactions) {
  if (transactions.isEmpty) {
    return StreakResult(currentStreak: 0, longestStreak: 0, noSpendDays: []);
  }

  final expenseDays = <DateTime>{};
  for (final tx in transactions) {
    if (tx.type == 'expense') {
      expenseDays.add(DateHelpers.normalizeDate(tx.date));
    }
  }

  final sortedTransactions = List<TransactionModel>.from(transactions)
    ..sort((a, b) => a.date.compareTo(b.date));
  final startDate = DateHelpers.normalizeDate(sortedTransactions.first.date);
  final yesterday = DateHelpers.normalizeDate(DateTime.now().subtract(const Duration(days: 1)));

  final noSpendDays = <DateTime>[];
  DateTime cursor = startDate;
  while (!cursor.isAfter(yesterday)) {
    if (!expenseDays.contains(cursor)) {
      noSpendDays.add(cursor);
    }
    cursor = cursor.add(const Duration(days: 1));
  }

  int currentStreak = 0;
  DateTime streakCursor = yesterday;
  while (!streakCursor.isBefore(startDate)) {
    if (expenseDays.contains(streakCursor)) {
      break;
    }
    currentStreak += 1;
    streakCursor = streakCursor.subtract(const Duration(days: 1));
  }

  int longestStreak = 0;
  int running = 0;
  cursor = startDate;
  while (!cursor.isAfter(yesterday)) {
    if (!expenseDays.contains(cursor)) {
      running += 1;
      if (running > longestStreak) {
        longestStreak = running;
      }
    } else {
      running = 0;
    }
    cursor = cursor.add(const Duration(days: 1));
  }

  return StreakResult(
    currentStreak: currentStreak,
    longestStreak: longestStreak,
    noSpendDays: noSpendDays,
  );
}