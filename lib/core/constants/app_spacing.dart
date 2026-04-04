import 'package:flutter/widgets.dart';

class AppSpacing {
  AppSpacing._();

  static const SizedBox xs = SizedBox(height: 4, width: 4);
  static const SizedBox sm = SizedBox(height: 8, width: 8);
  static const SizedBox md = SizedBox(height: 16, width: 16);
  static const SizedBox lg = SizedBox(height: 24, width: 24);
  static const SizedBox xl = SizedBox(height: 32, width: 32);

  static const EdgeInsets screenPadding = EdgeInsets.symmetric(horizontal: 20, vertical: 16);
  static const EdgeInsets cardPadding = EdgeInsets.all(16);
  static const EdgeInsets chipPadding = EdgeInsets.symmetric(horizontal: 12, vertical: 8);
  static const EdgeInsets listItemPadding = EdgeInsets.symmetric(horizontal: 16, vertical: 12);
}