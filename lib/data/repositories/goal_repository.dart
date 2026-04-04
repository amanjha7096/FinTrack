import 'package:injectable/injectable.dart';
import 'package:isar/isar.dart';

import '../models/app_settings_model.dart';
import '../models/budget_limit_model.dart';
import '../models/goal_settings_model.dart';
import 'i_goal_repository.dart';

@LazySingleton(as: IGoalRepository)
class GoalRepository implements IGoalRepository {
  GoalRepository(this._isar);

  final Isar _isar;

  @override
  Future<GoalSettingsModel> getGoalSettings() async {
    try {
      return await _isar.txn(() async {
        return await _isar.goalSettingsModels.get(1) ?? GoalSettingsModel();
      });
    } catch (error) {
      throw Exception('Failed to load goal settings: $error');
    }
  }

  @override
  Future<void> saveGoalSettings(GoalSettingsModel settings) async {
    try {
      await _isar.writeTxn(() async {
        await _isar.goalSettingsModels.put(settings);
      });
    } catch (error) {
      throw Exception('Failed to save goal settings: $error');
    }
  }

  @override
  Future<List<BudgetLimitModel>> getAllBudgetLimits() async {
    try {
      return await _isar.txn(() async {
        return _isar.budgetLimitModels.where().findAll();
      });
    } catch (error) {
      throw Exception('Failed to load budget limits: $error');
    }
  }

  @override
  Future<void> upsertBudgetLimit(BudgetLimitModel limit) async {
    try {
      await _isar.writeTxn(() async {
        await _isar.budgetLimitModels.put(limit);
      });
    } catch (error) {
      throw Exception('Failed to save budget limit: $error');
    }
  }

  @override
  Future<void> deleteBudgetLimit(int id) async {
    try {
      await _isar.writeTxn(() async {
        await _isar.budgetLimitModels.delete(id);
      });
    } catch (error) {
      throw Exception('Failed to delete budget limit: $error');
    }
  }

  @override
  Future<AppSettingsModel> getAppSettings() async {
    try {
      return await _isar.txn(() async {
        return await _isar.appSettingsModels.get(1) ?? AppSettingsModel();
      });
    } catch (error) {
      throw Exception('Failed to load app settings: $error');
    }
  }

  @override
  Future<void> saveAppSettings(AppSettingsModel settings) async {
    try {
      await _isar.writeTxn(() async {
        await _isar.appSettingsModels.put(settings);
      });
    } catch (error) {
      throw Exception('Failed to save app settings: $error');
    }
  }
}