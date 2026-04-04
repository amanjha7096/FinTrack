import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_cubit.dart';
import 'core/di/injection.dart';
import 'logic/goal_bloc/goal_bloc.dart';
import 'logic/goal_bloc/goal_event.dart';
import 'logic/insights_cubit/insights_cubit.dart';
import 'logic/transaction_bloc/transaction_bloc.dart';
import 'logic/transaction_bloc/transaction_event.dart';
import 'logic/transaction_bloc/transaction_state.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<TransactionBloc>(
          create: (context) => getIt<TransactionBloc>()..add(const LoadTransactions()),
        ),
        BlocProvider<GoalBloc>(
          create: (context) => getIt<GoalBloc>()..add(const LoadGoals()),
        ),
        BlocProvider<InsightsCubit>(
          create: (context) => getIt<InsightsCubit>(),
        ),
        BlocProvider<ThemeCubit>(
          create: (context) => getIt<ThemeCubit>()..loadTheme(),
        ),
      ],
      child: BlocListener<TransactionBloc, TransactionState>(
        listener: (context, state) {
          if (state is TransactionLoaded) {
            context.read<GoalBloc>().add(const LoadGoals());
          }
        },
        child: BlocBuilder<ThemeCubit, bool>(
          builder: (context, isDark) {
            return MaterialApp.router(
              title: 'FinTrack',
              theme: AppTheme.light(),
              darkTheme: AppTheme.dark(),
              themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
              routerConfig: AppRouter.router,
            );
          },
        ),
      ),
    );
  }
}