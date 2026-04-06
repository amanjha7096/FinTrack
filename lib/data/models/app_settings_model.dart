import 'package:isar/isar.dart';

part 'app_settings_model.g.dart';

@collection
class AppSettingsModel {
  Id id = 1;
  bool isDarkMode = false;
  bool hasSeededData = false;
  DateTime? firstLaunchDate;
  List<String> customCategories = [];
}
