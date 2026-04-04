import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class LoadingShimmer extends StatelessWidget {
  const LoadingShimmer({
    super.key,
    this.height = 120,
    this.radius = 12,
  });

  final double height;
  final double radius;

  @override
  Widget build(BuildContext context) {
    final baseColor = Theme.of(context).dividerColor.withOpacity(0.3);
    final highlightColor = Theme.of(context).dividerColor.withOpacity(0.1);
    return Shimmer.fromColors(
      baseColor: baseColor,
      highlightColor: highlightColor,
      child: Container(
        height: height,
        decoration: BoxDecoration(
          color: baseColor,
          borderRadius: BorderRadius.circular(radius),
        ),
      ),
    );
  }
}