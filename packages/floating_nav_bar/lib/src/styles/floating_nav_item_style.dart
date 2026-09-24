import 'package:flutter/widgets.dart';

/// Per-item overrides. Every `null` field falls back to [FloatingNavBarStyle].
///
/// Typically used for the detached trailing item, e.g. a highlighted
/// "Exchange" button with its own background and label color.
@immutable
class FloatingNavItemStyle {
  const FloatingNavItemStyle({
    this.backgroundColor,
    this.selectedColor,
    this.unselectedColor,
    this.indicatorColor,
    this.indicatorBorderColor,
    this.labelStyle,
    this.iconSize,
  });

  /// Surface color. Only used by the detached trailing item.
  final Color? backgroundColor;
  final Color? selectedColor;
  final Color? unselectedColor;
  final Color? indicatorColor;
  final Color? indicatorBorderColor;
  final TextStyle? labelStyle;
  final double? iconSize;

  @override
  bool operator ==(Object other) =>
      other is FloatingNavItemStyle &&
      other.backgroundColor == backgroundColor &&
      other.selectedColor == selectedColor &&
      other.unselectedColor == unselectedColor &&
      other.indicatorColor == indicatorColor &&
      other.indicatorBorderColor == indicatorBorderColor &&
      other.labelStyle == labelStyle &&
      other.iconSize == iconSize;

  @override
  int get hashCode => Object.hash(
    backgroundColor,
    selectedColor,
    unselectedColor,
    indicatorColor,
    indicatorBorderColor,
    labelStyle,
    iconSize,
  );
}
