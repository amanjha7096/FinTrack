import 'package:isar/isar.dart';

part 'transaction_model.g.dart';

@collection
class TransactionModel {
  Id id = Isar.autoIncrement;
  late String uuid;
  late double amount;
  late String type;
  late String category;
  late DateTime date;
  String? note;
  late DateTime createdAt;
  late DateTime updatedAt;
  late bool isSeeded;
}