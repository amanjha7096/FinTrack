import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

import 'app.dart';
import 'core/constants/seed_data.dart';
import 'core/di/injection.dart';
import 'data/models/app_settings_model.dart';
import 'data/models/budget_limit_model.dart';
import 'data/models/goal_settings_model.dart';
import 'data/models/transaction_model.dart';
import 'data/repositories/i_goal_repository.dart';
import 'data/repositories/i_transaction_repository.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final dir = await getApplicationDocumentsDirectory();
  final isar = await Isar.open(
    [
      TransactionModelSchema,
      GoalSettingsModelSchema,
      BudgetLimitModelSchema,
      AppSettingsModelSchema,
    ],
    directory: dir.path,
  );

  configureDependencies(isar);
  final transactionRepo = getIt<ITransactionRepository>();
  final goalRepo = getIt<IGoalRepository>();

  final settings = await goalRepo.getAppSettings();
  if (!settings.hasSeededData) {
    await transactionRepo.seedIfEmpty(SeedData.all);
    settings.hasSeededData = true;
    settings.firstLaunchDate = DateTime.now();
    await goalRepo.saveAppSettings(settings);
  }

  runApp(const App());
}
