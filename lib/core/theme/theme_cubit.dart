import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../data/repositories/i_goal_repository.dart';
@injectable
class ThemeCubit extends Cubit<bool> {
  ThemeCubit(this._goalRepository) : super(false);

  final IGoalRepository _goalRepository;

  Future<void> loadTheme() async {
    final settings = await _goalRepository.getAppSettings();
    emit(settings.isDarkMode);
  }

  Future<void> toggleTheme() async {
    final settings = await _goalRepository.getAppSettings();
    settings.isDarkMode = !settings.isDarkMode;
    await _goalRepository.saveAppSettings(settings);
    emit(settings.isDarkMode);
  }
}