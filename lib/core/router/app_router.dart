import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../ui/screens/goals/goals_screen.dart';
import '../../ui/screens/home/home_screen.dart';
import '../../ui/screens/insights/insights_screen.dart';
import '../../ui/screens/transactions/transactions_screen.dart';
import '../../ui/shared/app_scaffold.dart';

class AppRouter {
  AppRouter._();

  static final _rootNavigatorKey = GlobalKey<NavigatorState>();
  static final _homeNavigatorKey = GlobalKey<NavigatorState>();
  static final _transactionsNavigatorKey = GlobalKey<NavigatorState>();
  static final _insightsNavigatorKey = GlobalKey<NavigatorState>();
  static final _goalsNavigatorKey = GlobalKey<NavigatorState>();

  static GoRouter router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/',
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return AppScaffold(shell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            navigatorKey: _homeNavigatorKey,
            routes: [
              GoRoute(
                path: '/',
                pageBuilder: (context, state) => _buildPage(const HomeScreen()),
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _transactionsNavigatorKey,
            routes: [
              GoRoute(
                path: '/transactions',
                pageBuilder: (context, state) => _buildPage(const TransactionsScreen()),
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _insightsNavigatorKey,
            routes: [
              GoRoute(
                path: '/insights',
                pageBuilder: (context, state) => _buildPage(const InsightsScreen()),
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _goalsNavigatorKey,
            routes: [
              GoRoute(
                path: '/goals',
                pageBuilder: (context, state) => _buildPage(const GoalsScreen()),
              ),
            ],
          ),
        ],
      ),
    ],
  );

  static CustomTransitionPage<void> _buildPage(Widget child) {
    return CustomTransitionPage<void>(
      child: child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(opacity: animation, child: child);
      },
      transitionDuration: const Duration(milliseconds: 200),
    );
  }
}