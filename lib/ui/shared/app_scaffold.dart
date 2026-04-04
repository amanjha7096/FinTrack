import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

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
    return Scaffold(
      body: shell,
      floatingActionButton: AppFab(
        onPressed: () {
          final bloc = BlocProvider.of<TransactionBloc>(context);
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            useSafeArea: true,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            builder: (context) {
              return BlocProvider.value(
                value: bloc,
                child: const AddEditTransactionSheet(),
              );
            },
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: shell.currentIndex,
        onTap: _onTap,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.list_alt_outlined), label: 'Transactions'),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart_outlined), label: 'Insights'),
          BottomNavigationBarItem(icon: Icon(Icons.star_outline), label: 'Goals'),
        ],
      ),
    );
  }
}