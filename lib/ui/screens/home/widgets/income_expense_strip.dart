// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
//
// import '../../../../core/constants/app_colors.dart';
//
// class IncomeExpenseStrip extends StatelessWidget {
//   const IncomeExpenseStrip({
//     super.key,
//     required this.income,
//     required this.expense,
//   });
//
//   final double income;
//   final double expense;
//
//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       children: [
//         Expanded(
//           child: _StatCard(
//             title: 'Income',
//             value: income,
//             color: AppColors.income,
//             icon: Icons.arrow_upward_rounded,
//           ),
//         ),
//         const SizedBox(width: 12),
//         Expanded(
//           child: _StatCard(
//             title: 'Expenses',
//             value: expense,
//             color: AppColors.expense,
//             icon: Icons.arrow_downward_rounded,
//           ),
//         ),
//       ],
//     );
//   }
// }
//
// class _StatCard extends StatelessWidget {
//   const _StatCard({
//     required this.title,
//     required this.value,
//     required this.color,
//     required this.icon,
//   });
//
//   final String title;
//   final double value;
//   final Color color;
//   final IconData icon;
//
//   @override
//   Widget build(BuildContext context) {
//     final reduced = MediaQuery.of(context).disableAnimations;
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Theme.of(context).cardColor,
//         borderRadius: BorderRadius.circular(20),
//         border: Border.all(color: Theme.of(context).dividerColor),
//       ),
//       child: Row(
//         children: [
//           Container(
//             width: 36,
//             height: 36,
//             decoration: BoxDecoration(
//               color: color.withValues(alpha: 0.18),
//               borderRadius: BorderRadius.circular(12),
//             ),
//             child: Icon(icon, size: 18, color: color),
//           ),
//           const SizedBox(width: 12),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(title, style: Theme.of(context).textTheme.bodySmall),
//                 const SizedBox(height: 4),
//                 TweenAnimationBuilder<double>(
//                   tween: Tween<double>(begin: 0, end: value),
//                   duration: reduced ? Duration.zero : const Duration(milliseconds: 800),
//                   curve: Curves.easeOutCubic,
//                   builder: (context, amount, child) {
//                     return Text(
//                       '\u20B9${NumberFormat('#,##,###').format(amount.toInt())}',
//                       style: Theme.of(context).textTheme.titleMedium?.copyWith(
//                             color: color,
//                             fontWeight: FontWeight.w600,
//                           ),
//                     );
//                   },
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
