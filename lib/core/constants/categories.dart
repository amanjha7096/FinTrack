import 'package:flutter/material.dart';

import 'app_colors.dart';

class TransactionCategory {
  const TransactionCategory({
    required this.key,
    required this.label,
    required this.icon,
    required this.color,
  });

  final String key;
  final String label;
  final IconData icon;
  final Color color;
}

class Categories {
  Categories._();

  static const food = TransactionCategory(
    key: 'food',
    label: 'Food & Dining',
    icon: Icons.restaurant,
    color: AppColors.food,
  );
  static const transport = TransactionCategory(
    key: 'transport',
    label: 'Transport',
    icon: Icons.directions_car,
    color: AppColors.transport,
  );
  static const shopping = TransactionCategory(
    key: 'shopping',
    label: 'Shopping',
    icon: Icons.shopping_bag,
    color: AppColors.shopping,
  );
  static const entertainment = TransactionCategory(
    key: 'entertainment',
    label: 'Entertainment',
    icon: Icons.movie,
    color: AppColors.entertainment,
  );
  static const health = TransactionCategory(
    key: 'health',
    label: 'Health & Medical',
    icon: Icons.local_hospital,
    color: AppColors.health,
  );
  static const utilities = TransactionCategory(
    key: 'utilities',
    label: 'Bills & Utilities',
    icon: Icons.receipt_long,
    color: AppColors.utilities,
  );
  static const education = TransactionCategory(
    key: 'education',
    label: 'Education',
    icon: Icons.school,
    color: AppColors.education,
  );
  static const travel = TransactionCategory(
    key: 'travel',
    label: 'Travel',
    icon: Icons.flight,
    color: AppColors.travel,
  );
  static const personal = TransactionCategory(
    key: 'personal',
    label: 'Personal Care',
    icon: Icons.self_improvement,
    color: AppColors.personal,
  );
  static const home = TransactionCategory(
    key: 'home',
    label: 'Home & Rent',
    icon: Icons.home,
    color: AppColors.home,
  );
  static const salary = TransactionCategory(
    key: 'salary',
    label: 'Salary',
    icon: Icons.account_balance_wallet,
    color: AppColors.salary,
  );
  static const otherIncome = TransactionCategory(
    key: 'other_income',
    label: 'Other Income',
    icon: Icons.add_circle_outline,
    color: AppColors.otherIncome,
  );

  static const all = <TransactionCategory>[
    food,
    transport,
    shopping,
    entertainment,
    health,
    utilities,
    education,
    travel,
    personal,
    home,
    salary,
    otherIncome,
  ];

  static const expense = <TransactionCategory>[
    food,
    transport,
    shopping,
    entertainment,
    health,
    utilities,
    education,
    travel,
    personal,
    home,
  ];

  static const income = <TransactionCategory>[salary, otherIncome];

  static List<String> get allKeys => all.map((category) => category.key).toList();

  static TransactionCategory? byKey(String key) {
    for (final category in all) {
      if (category.key == key) {
        return category;
      }
    }
    if (key.trim().isEmpty) {
      return null;
    }
    return TransactionCategory(
      key: key,
      label: key,
      icon: Icons.sell_rounded,
      color: AppColors.accent,
    );
  }

  static List<TransactionCategory> withCustom(
    List<String> customCategories, {
    String? type,
  }) {
    final base = switch (type) {
      'income' => income,
      'expense' => expense,
      _ => all,
    };
    final baseKeys = base.map((category) => category.key).toSet();
    final custom = customCategories
        .map((label) => label.trim())
        .where((label) => label.isNotEmpty && !baseKeys.contains(label))
        .map(
          (label) => TransactionCategory(
            key: label,
            label: label,
            icon: Icons.sell_rounded,
            color: AppColors.accent,
          ),
        )
        .toList();
    return [...base, ...custom];
  }
}
