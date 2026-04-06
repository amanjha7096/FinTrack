import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';

enum EmptyStateVariant {
  generic,
  home,
  transactions,
  insights,
  goals,
}

class EmptyStateView extends StatelessWidget {
  const EmptyStateView({
    super.key,
    required this.title,
    required this.subtitle,
    this.ctaLabel,
    this.onCta,
    this.icon = Icons.inbox_outlined,
    this.animated = false,
    this.variant = EmptyStateVariant.generic,
  });

  final String title;
  final String subtitle;
  final String? ctaLabel;
  final VoidCallback? onCta;
  final IconData icon;
  final bool animated;
  final EmptyStateVariant variant;

  @override
  Widget build(BuildContext context) {
    final illustration = switch (variant) {
      EmptyStateVariant.home => const _WalletEmptyIllustration(),
      EmptyStateVariant.transactions => const _ReceiptEmptyIllustration(),
      EmptyStateVariant.insights => const _GhostChartIllustration(),
      EmptyStateVariant.goals => const _PadlockEmptyIllustration(),
      EmptyStateVariant.generic => animated
          ? _AnimatedEmptyIcon(icon: icon)
          : Icon(icon, size: 64, color: Theme.of(context).colorScheme.secondary),
    };

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 150, child: Center(child: illustration)),
            const SizedBox(height: 20),
            Text(
              title,
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            if (ctaLabel != null && onCta != null) ...[
              const SizedBox(height: 20),
              FilledButton(
                onPressed: onCta,
                style: FilledButton.styleFrom(
                  minimumSize: const Size(200, 52),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                  backgroundColor: AppColors.income,
                  foregroundColor: AppColors.softIvory,
                ),
                child: Text(ctaLabel!),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _AnimatedEmptyIcon extends StatefulWidget {
  const _AnimatedEmptyIcon({required this.icon});

  final IconData icon;

  @override
  State<_AnimatedEmptyIcon> createState() => _AnimatedEmptyIconState();
}

class _AnimatedEmptyIconState extends State<_AnimatedEmptyIcon>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    final reduced = MediaQuery.maybeOf(context)?.disableAnimations ?? false;
    _controller = AnimationController(
      vsync: this,
      duration: reduced ? Duration.zero : const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: 0.9, end: 1.05).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _animation,
      child: Icon(widget.icon, size: 64, color: Theme.of(context).colorScheme.secondary),
    );
  }
}

class _WalletEmptyIllustration extends StatefulWidget {
  const _WalletEmptyIllustration();

  @override
  State<_WalletEmptyIllustration> createState() => _WalletEmptyIllustrationState();
}

class _WalletEmptyIllustrationState extends State<_WalletEmptyIllustration>
    with TickerProviderStateMixin {
  late final AnimationController _entryController;
  late final AnimationController _floatController;
  late final AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    final reduced = MediaQuery.maybeOf(context)?.disableAnimations ?? false;
    _entryController = AnimationController(
      vsync: this,
      duration: reduced ? Duration.zero : const Duration(milliseconds: 600),
    )..forward();
    _floatController = AnimationController(
      vsync: this,
      duration: reduced ? Duration.zero : const Duration(milliseconds: 3000),
    )..repeat(reverse: true);
    _pulseController = AnimationController(
      vsync: this,
      duration: reduced ? Duration.zero : const Duration(milliseconds: 2000),
    )..repeat();
  }

  @override
  void dispose() {
    _entryController.dispose();
    _floatController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_entryController, _floatController, _pulseController]),
      builder: (context, child) {
        final entry = Curves.easeOut.transform(_entryController.value);
        final bob = (_floatController.value - 0.5) * 8;
        final pulse = Curves.easeInOut.transform(_pulseController.value);
        return Opacity(
          opacity: entry,
          child: Transform.translate(
            offset: Offset(0, (1 - entry) * 12 - bob),
            child: SizedBox(
              width: 120,
              height: 100,
              child: Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.center,
                children: [
                  CustomPaint(
                    size: const Size(70, 54),
                    painter: _WalletPainter(),
                  ),
                  Positioned(
                    top: 6,
                    right: 10,
                    child: Opacity(
                      opacity: 1 - pulse,
                      child: Transform.scale(
                        scale: 1 + (pulse * 0.6),
                        child: Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: AppColors.warning,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _ReceiptEmptyIllustration extends StatefulWidget {
  const _ReceiptEmptyIllustration();

  @override
  State<_ReceiptEmptyIllustration> createState() => _ReceiptEmptyIllustrationState();
}

class _ReceiptEmptyIllustrationState extends State<_ReceiptEmptyIllustration>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    final reduced = MediaQuery.maybeOf(context)?.disableAnimations ?? false;
    _controller = AnimationController(
      vsync: this,
      duration: reduced ? Duration.zero : const Duration(milliseconds: 2400),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          size: const Size(72, 96),
          painter: _ReceiptPainter(progress: _controller.value, isDark: Theme.of(context).brightness == Brightness.dark),
        );
      },
    );
  }
}

class _GhostChartIllustration extends StatefulWidget {
  const _GhostChartIllustration();

  @override
  State<_GhostChartIllustration> createState() => _GhostChartIllustrationState();
}

class _GhostChartIllustrationState extends State<_GhostChartIllustration>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    final reduced = MediaQuery.maybeOf(context)?.disableAnimations ?? false;
    _controller = AnimationController(
      vsync: this,
      duration: reduced ? Duration.zero : const Duration(milliseconds: 2000),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final opacity = 0.4 + (_controller.value * 0.4);
        final isDark = Theme.of(context).brightness == Brightness.dark;
        final barColor = (isDark ? AppColors.darkTextHint : AppColors.lightTextHint)
            .withValues(alpha: 0.25 + (_controller.value * 0.1));
        return Opacity(
          opacity: opacity,
          child: SizedBox(
            width: 220,
            height: 140,
            child: BarChart(
              BarChartData(
                barTouchData: const BarTouchData(enabled: false),
                gridData: const FlGridData(show: false),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 18,
                      getTitlesWidget: (value, meta) => Text(
                        '—',
                        style: Theme.of(context).textTheme.labelSmall,
                      ),
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) => Text(
                        '—',
                        style: Theme.of(context).textTheme.labelSmall,
                      ),
                    ),
                  ),
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                borderData: FlBorderData(
                  show: true,
                  border: Border(
                    left: BorderSide(
                      color: (isDark ? AppColors.darkBorder : AppColors.lightBorder).withValues(alpha: 0.7),
                    ),
                    bottom: BorderSide(
                      color: (isDark ? AppColors.darkBorder : AppColors.lightBorder).withValues(alpha: 0.7),
                    ),
                  ),
                ),
                barGroups: [40, 70, 55, 85, 30]
                    .asMap()
                    .entries
                    .map(
                      (entry) => BarChartGroupData(
                        x: entry.key,
                        barRods: [
                          BarChartRodData(
                            toY: entry.value.toDouble(),
                            color: barColor,
                            width: 18,
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ],
                      ),
                    )
                    .toList(),
                maxY: 100,
              ),
            ),
          ),
        );
      },
    );
  }
}

class _PadlockEmptyIllustration extends StatefulWidget {
  const _PadlockEmptyIllustration();

  @override
  State<_PadlockEmptyIllustration> createState() => _PadlockEmptyIllustrationState();
}

class _PadlockEmptyIllustrationState extends State<_PadlockEmptyIllustration>
    with TickerProviderStateMixin {
  late final AnimationController _unlockController;
  late final AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    final reduced = MediaQuery.maybeOf(context)?.disableAnimations ?? false;
    _unlockController = AnimationController(
      vsync: this,
      duration: reduced ? Duration.zero : const Duration(milliseconds: 900),
    )..forward();
    _pulseController = AnimationController(
      vsync: this,
      duration: reduced ? Duration.zero : const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _unlockController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_unlockController, _pulseController]),
      builder: (context, child) {
        final unlock = _unlockController.value;
        final shackleOffset = (unlock < 0.45
            ? Curves.easeOut.transform(unlock / 0.45) * 8
            : unlock < 0.66
                ? 8
                : (1 - Curves.elasticOut.transform((unlock - 0.66) / 0.34)) * 8)
            .toDouble();
        return Transform.scale(
          scale: 1 + (_pulseController.value * 0.05),
          child: CustomPaint(
            size: const Size(88, 96),
            painter: _PadlockPainter(
              shackleOffset: shackleOffset,
              isDark: Theme.of(context).brightness == Brightness.dark,
            ),
          ),
        );
      },
    );
  }
}

class _WalletPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final bodyPaint = Paint()..color = AppColors.income;
    final flapPaint = Paint()..color = AppColors.gradientTealStart;
    final cutoutPaint = Paint()..color = AppColors.softIvory.withValues(alpha: 0.75);

    final body = RRect.fromRectAndRadius(
      Rect.fromLTWH(10, 18, 48, 36),
      const Radius.circular(12),
    );
    final flap = RRect.fromRectAndRadius(
      Rect.fromLTWH(16, 12, 44, 20),
      const Radius.circular(10),
    );

    canvas.drawRRect(body, bodyPaint);
    canvas.drawRRect(flap, flapPaint);
    canvas.drawCircle(const Offset(47, 36), 3, cutoutPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _ReceiptPainter extends CustomPainter {
  const _ReceiptPainter({required this.progress, required this.isDark});

  final double progress;
  final bool isDark;

  @override
  void paint(Canvas canvas, Size size) {
    final surface = isDark ? AppColors.darkCardAlt : AppColors.lightCardAlt;
    final lineColor = (isDark ? AppColors.darkTextSub : AppColors.lightTextSub).withValues(alpha: 0.55);
    final body = RRect.fromRectAndRadius(
      Rect.fromLTWH(16, 10, 40, 56),
      const Radius.circular(12),
    );
    canvas.drawRRect(body, Paint()..color = surface);

    for (var i = 0; i < 3; i++) {
      final phase = ((progress - (i * 0.12)) % 1.0).clamp(0.0, 1.0);
      final width = Curves.easeOut.transform(phase) * 22;
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(25, 24 + (i * 10), width, 4),
          const Radius.circular(2),
        ),
        Paint()..color = lineColor,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _ReceiptPainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.isDark != isDark;
  }
}

class _PadlockPainter extends CustomPainter {
  const _PadlockPainter({
    required this.shackleOffset,
    required this.isDark,
  });

  final double shackleOffset;
  final bool isDark;

  @override
  void paint(Canvas canvas, Size size) {
    final color = isDark ? AppColors.darkTextSub : AppColors.lightTextSub;
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;
    final fillPaint = Paint()..color = color.withValues(alpha: 0.75);

    final body = RRect.fromRectAndRadius(
      Rect.fromLTWH(24, 42, 36, 30),
      const Radius.circular(10),
    );
    canvas.drawRRect(body, fillPaint);

    final path = Path()
      ..moveTo(32, 42)
      ..quadraticBezierTo(32, 18 - shackleOffset, 42, 18 - shackleOffset)
      ..quadraticBezierTo(52, 18 - shackleOffset, 52, 42);
    canvas.drawPath(path, paint);

    canvas.drawCircle(const Offset(42, 55), 3, Paint()..color = AppColors.ink);
    final keyhole = Path()
      ..moveTo(42, 58)
      ..lineTo(39, 64)
      ..lineTo(45, 64)
      ..close();
    canvas.drawPath(keyhole, Paint()..color = AppColors.ink);
  }

  @override
  bool shouldRepaint(covariant _PadlockPainter oldDelegate) {
    return oldDelegate.shackleOffset != shackleOffset || oldDelegate.isDark != isDark;
  }
}
