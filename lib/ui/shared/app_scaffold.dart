import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_colors.dart';
import 'app_fab.dart';
import '../screens/transactions/widgets/add_edit_transaction_sheet.dart';
import '../../logic/transaction_bloc/transaction_bloc.dart';

class AppScaffold extends StatelessWidget {
  const AppScaffold({
    super.key,
    required this.shell,
  });

  final StatefulNavigationShell shell;

  void _onTap(int index) {
    shell.goBranch(index, initialLocation: index == shell.currentIndex);
  }

  @override
  Widget build(BuildContext context) {
    final navItems = <BottomNavigationBarItem>[
      BottomNavigationBarItem(
        icon: Icon(shell.currentIndex == 0 ? Icons.home_rounded : Icons.home_outlined),
        label: 'Home',
      ),
      BottomNavigationBarItem(
        icon: Icon(shell.currentIndex == 1 ? Icons.account_balance_wallet_rounded : Icons.account_balance_wallet_outlined),
        label: 'Balances',
      ),
      BottomNavigationBarItem(
        icon: Icon(shell.currentIndex == 2 ? Icons.bar_chart_rounded : Icons.bar_chart_outlined),
        label: 'Insights',
      ),
      BottomNavigationBarItem(
        icon: Icon(shell.currentIndex == 3 ? Icons.star_rounded : Icons.star_outline_rounded),
        label: 'Goals',
      ),
    ];

    return Scaffold(
      body: shell,
      floatingActionButton: AppFab(
        onPressed: () {
          final bloc = BlocProvider.of<TransactionBloc>(context);
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            useSafeArea: true,
            backgroundColor: Colors.transparent,
            barrierColor: AppColors.ink.withValues(alpha: 0.6),
            builder: (context) {
              return BlocProvider.value(
                value: bloc,
                child: const _SheetFrame(child: AddEditTransactionSheet()),
              );
            },
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).bottomNavigationBarTheme.backgroundColor,
          border: Border(
            top: BorderSide(color: Theme.of(context).dividerColor),
          ),
        ),
        child: SafeArea(
          top: false,
          child: BottomNavigationBar(
            currentIndex: shell.currentIndex,
            onTap: _onTap,
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.transparent,
            items: navItems,
          ),
        ),
      ),
    );
  }
}

class _SheetFrame extends StatelessWidget {
  const _SheetFrame({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Center(
            child: Container(
              margin: const EdgeInsets.only(top: 12, bottom: 8),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.textSubtle.withValues(alpha: 0.4),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          Flexible(child: child),
        ],
      ),
    );
  }
}
