import 'package:isar/isar.dart';

part 'goal_settings_model.g.dart';

@collection
class GoalSettingsModel {
  Id id = 1;
  double savingsGoalAmount = 0;
  DateTime? goalStartDate;
  bool isGoalActive = false;
}