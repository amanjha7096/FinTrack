import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';

class AppFab extends StatelessWidget {
  const AppFab({
    super.key,
    required this.onPressed,
  });

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final isKeyboardVisible = MediaQuery.of(context).viewInsets.bottom > 0;
    final reduced = MediaQuery.of(context).disableAnimations;
    final duration = reduced ? Duration.zero : const Duration(milliseconds: 150);
    return AnimatedScale(
      scale: isKeyboardVisible ? 0.8 : 1,
      duration: duration,
      child: AnimatedOpacity(
        opacity: isKeyboardVisible ? 0 : 1,
        duration: duration,
        child: FloatingActionButton(
          onPressed: onPressed,
          backgroundColor: AppColors.softIvory,
          foregroundColor: AppColors.graphite,
          child: const Icon(Icons.add, size: 22),
        ),
      ),
    );
  }
}
