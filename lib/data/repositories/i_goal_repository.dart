import '../models/app_settings_model.dart';
import '../models/budget_limit_model.dart';
import '../models/goal_settings_model.dart';

abstract class IGoalRepository {
  Future<GoalSettingsModel> getGoalSettings();

  Future<void> saveGoalSettings(GoalSettingsModel settings);

  Future<List<BudgetLimitModel>> getAllBudgetLimits();

  Future<void> upsertBudgetLimit(BudgetLimitModel limit);

  Future<void> deleteBudgetLimit(int id);

  Future<AppSettingsModel> getAppSettings();

  Future<void> saveAppSettings(AppSettingsModel settings);
}