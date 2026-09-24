import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../styles/floating_nav_bar_style.dart';

/// Positions a bar: side margins, fixed height and the bottom safe area.
class NavBarFrame extends StatelessWidget {
  const NavBarFrame({super.key, required this.style, required this.child});

  final FloatingNavBarStyle style;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final margin = style.margin;
    final safeBottom = MediaQuery.paddingOf(context).bottom;
    final bottomInset =
        defaultTargetPlatform == TargetPlatform.iOS && safeBottom > 0
        ? math.min(safeBottom, style.homeIndicatorSpacing)
        : safeBottom;
    return Padding(
      padding: EdgeInsets.fromLTRB(
        margin.left,
        margin.top,
        margin.right,
        math.max(bottomInset, style.minBottomSpacing) + margin.bottom,
      ),
      child: SizedBox(height: style.height, child: child),
    );
  }
}
