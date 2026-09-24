import 'dart:ui' show ImageFilter;

import 'package:flutter/widgets.dart';

import '../styles/floating_nav_bar_style.dart';

/// Rounded background of the main bar and of the trailing item.
class NavBarSurface extends StatelessWidget {
  const NavBarSurface({
    super.key,
    required this.style,
    required this.color,
    required this.child,
  });

  final FloatingNavBarStyle style;
  final Color color;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(style.height / 2);
    final content = DecoratedBox(
      decoration: BoxDecoration(
        color: color,
        border: style.border,
        borderRadius: radius,
      ),
      child: Padding(padding: style.padding, child: child),
    );

    final Widget surface = style.blurSigma > 0
        ? ClipRRect(
            borderRadius: radius,
            child: BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: style.blurSigma,
                sigmaY: style.blurSigma,
              ),
              child: content,
            ),
          )
        : content;

    if (style.shadows.isEmpty) return surface;
    // Shadows live outside the clip so the blur does not cut them off.
    return DecoratedBox(
      decoration: BoxDecoration(borderRadius: radius, boxShadow: style.shadows),
      child: surface,
    );
  }
}
