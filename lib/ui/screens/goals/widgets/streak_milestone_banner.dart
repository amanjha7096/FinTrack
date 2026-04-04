import 'package:flutter/material.dart';

class StreakMilestoneBanner extends StatefulWidget {
  const StreakMilestoneBanner({super.key, required this.currentStreak});

  final int currentStreak;

  @override
  State<StreakMilestoneBanner> createState() => _StreakMilestoneBannerState();
}

class _StreakMilestoneBannerState extends State<StreakMilestoneBanner>
    with SingleTickerProviderStateMixin {
  AnimationController? _controller;

  @override
  void didUpdateWidget(covariant StreakMilestoneBanner oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_isMilestone(widget.currentStreak)) {
      _controller?.dispose();
      _controller = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 400),
      )..forward();
    }
  }

  @override
  void initState() {
    super.initState();
    if (_isMilestone(widget.currentStreak)) {
      _controller = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 400),
      )..forward();
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  bool _isMilestone(int streak) => [3, 7, 14, 30].contains(streak);

  @override
  Widget build(BuildContext context) {
    if (!_isMilestone(widget.currentStreak)) {
      return const SizedBox.shrink();
    }
    final animation = _controller ??
        AnimationController(vsync: this, duration: const Duration(milliseconds: 400))
          ..forward();
    return SlideTransition(
      position: Tween<Offset>(begin: const Offset(0, -0.3), end: Offset.zero).animate(
        CurvedAnimation(parent: animation, curve: Curves.elasticOut),
      ),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primaryContainer,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            const Icon(Icons.emoji_events, color: Colors.orange),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'Milestone unlocked: ${widget.currentStreak}-day streak!',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          ],
        ),
      ),
    );
  }
}