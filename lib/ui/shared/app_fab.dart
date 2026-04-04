import 'package:flutter/material.dart';

class AppFab extends StatelessWidget {
  const AppFab({
    super.key,
    required this.onPressed,
  });

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final isKeyboardVisible = MediaQuery.of(context).viewInsets.bottom > 0;
    return AnimatedScale(
      scale: isKeyboardVisible ? 0.8 : 1,
      duration: const Duration(milliseconds: 150),
      child: AnimatedOpacity(
        opacity: isKeyboardVisible ? 0 : 1,
        duration: const Duration(milliseconds: 150),
        child: FloatingActionButton(
          onPressed: onPressed,
          backgroundColor: Theme.of(context).colorScheme.primary,
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}