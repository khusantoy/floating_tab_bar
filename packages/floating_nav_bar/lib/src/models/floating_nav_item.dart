import 'package:flutter/widgets.dart';

import '../styles/floating_nav_item_style.dart';

/// Builds an item icon for the Flutter bar with the current animated [color].
///
/// Useful for widgets that do not read [IconTheme], such as `SvgPicture`.
typedef FloatingNavIconBuilder = Widget Function(
  BuildContext context,
  Color color,
  bool selected,
);

/// A single destination of [FloatingNavBar].
@immutable
class FloatingNavItem {
  const FloatingNavItem({
    required this.label,
    this.icon,
    this.activeIcon,
    this.iconBuilder,
    this.style,
    this.semanticLabel,
  }) : assert(
         icon != null || iconBuilder != null,
         'Provide either icon or iconBuilder',
       );

  final String label;

  /// Icon for the Flutter bar. Colored through [IconTheme].
  final Widget? icon;

  /// Icon shown while the item is selected. Defaults to [icon].
  final Widget? activeIcon;

  /// Alternative to [icon]/[activeIcon] for widgets that ignore [IconTheme].
  final FloatingNavIconBuilder? iconBuilder;

  /// Per-item overrides on top of the bar style.
  final FloatingNavItemStyle? style;

  final String? semanticLabel;

  @override
  bool operator ==(Object other) =>
      other is FloatingNavItem &&
      other.label == label &&
      other.icon == icon &&
      other.activeIcon == activeIcon &&
      other.iconBuilder == iconBuilder &&
      other.style == style &&
      other.semanticLabel == semanticLabel;

  @override
  int get hashCode =>
      Object.hash(label, icon, activeIcon, iconBuilder, style, semanticLabel);
}
