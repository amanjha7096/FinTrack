import 'package:isar/isar.dart';

part 'budget_limit_model.g.dart';

@collection
class BudgetLimitModel {
  Id id = Isar.autoIncrement;
  late String category;
  late double limitAmount;
  late DateTime createdAt;
}