// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:finance_app/core/theme/theme_cubit.dart' as _i9;
import 'package:finance_app/data/repositories/goal_repository.dart' as _i4;
import 'package:finance_app/data/repositories/i_goal_repository.dart' as _i3;
import 'package:finance_app/data/repositories/i_transaction_repository.dart'
    as _i6;
import 'package:finance_app/data/repositories/transaction_repository.dart'
    as _i7;
import 'package:finance_app/logic/goal_bloc/goal_bloc.dart' as _i11;
import 'package:finance_app/logic/insights_cubit/insights_cubit.dart' as _i8;
import 'package:finance_app/logic/transaction_bloc/transaction_bloc.dart'
    as _i10;
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;
import 'package:isar/isar.dart' as _i5;

extension GetItInjectableX on _i1.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  _i1.GetIt init({
    String? environment,
    _i2.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i2.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    gh.lazySingleton<_i3.IGoalRepository>(
        () => _i4.GoalRepository(gh<_i5.Isar>()));
    gh.lazySingleton<_i6.ITransactionRepository>(
        () => _i7.TransactionRepository(gh<_i5.Isar>()));
    gh.factory<_i8.InsightsCubit>(() => _i8.InsightsCubit(
          gh<_i6.ITransactionRepository>(),
          gh<_i3.IGoalRepository>(),
        ));
    gh.factory<_i9.ThemeCubit>(() => _i9.ThemeCubit(gh<_i3.IGoalRepository>()));
    gh.factory<_i10.TransactionBloc>(
        () => _i10.TransactionBloc(gh<_i6.ITransactionRepository>()));
    gh.factory<_i11.GoalBloc>(() => _i11.GoalBloc(
          gh<_i3.IGoalRepository>(),
          gh<_i6.ITransactionRepository>(),
        ));
    return this;
  }
}
