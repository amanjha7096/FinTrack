import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:isar/isar.dart';

import 'injection.config.dart';

final GetIt getIt = GetIt.instance;

@InjectableInit()
void configureDependencies(Isar isar) {
  if (getIt.isRegistered<Isar>()) {
    return;
  }
  getIt.registerSingleton<Isar>(isar);
  getIt.init();
}