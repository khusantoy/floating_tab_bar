import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';

import 'floating_nav_item_style.dart';

/// Visual configuration of [FloatingNavBar].
///
/// Defaults follow the Figma spec: 18px side margins, 62px bar, 56px
/// selection pill, 4px gap before the detached trailing item.
@immutable
class FloatingNavBarStyle {
  const FloatingNavBarStyle({
    this.margin = const EdgeInsets.symmetric(horizontal: 18),
    this.minBottomSpacing = 12,
    this.homeIndicatorSpacing = 20,
    this.height = 62,
    this.padding = const EdgeInsets.all(3),
    this.trailingGap = 4,
    this.trailingWidth,
    this.backgroundColor = const Color(0xFFF0F4FF),
    this.border,
    this.shadows = const [],
    this.blurSigma = 0,
    this.selectedColor = const Color(0xFF405F8F),
    this.unselectedColor = const Color(0xFF575757),
    this.indicatorColor = const Color(0x1A4469A2),
    this.indicatorBorderColor = const Color(0x1A4469A2),
    this.indicatorBorderWidth = 1,
    this.iconSize = 24,
    this.iconLabelGap = 2,
    this.labelStyle = const TextStyle(
      fontSize: 10,
      height: 1,
      fontWeight: FontWeight.w600,
    ),
    this.maxLabelTextScale = 1.2,
    this.pressedScale = 0.9,
    this.pressDuration = const Duration(milliseconds: 110),
    this.indicatorInDuration = const Duration(milliseconds: 260),
    this.indicatorOutDuration = const Duration(milliseconds: 180),
    this.indicatorInScale = 0.9,
    this.enableHaptics = true,
  });

  /// Space around the bar. The bottom safe-area inset is added on top.
  final EdgeInsets margin;

  /// Minimum gap to the screen bottom when the safe-area inset is smaller
  /// (e.g. Android 3-button navigation).
  final double minBottomSpacing;

  /// Gap to the screen bottom on iOS devices with a home indicator. The full
  /// bottom inset (34pt) leaves an empty band under a floating bar; the
  /// indicator itself only needs ~13pt, so the bar sits lower, like the
  /// iOS 26 tab bar. Android keeps the full inset, since 3-button navigation
  /// may live there.
  final double homeIndicatorSpacing;

  /// Height of the bar and of the detached trailing item.
  final double height;

  /// Inset between the bar edge and the item slots. The selection pill fills
  /// a slot, so its height is `height - padding.vertical`.
  final EdgeInsets padding;

  /// Horizontal gap between the main bar and the trailing item.
  final double trailingGap;

  /// Width of the trailing item. Defaults to [height] (a circle).
  final double? trailingWidth;

  final Color backgroundColor;
  final BoxBorder? border;
  final List<BoxShadow> shadows;

  /// Backdrop blur behind the bar. `0` disables it, which is much cheaper and
  /// the right choice for an opaque [backgroundColor].
  final double blurSigma;

  /// Icon and label color of the selected item.
  final Color selectedColor;

  /// Icon and label color of unselected items.
  final Color unselectedColor;

  final Color indicatorColor;
  final Color indicatorBorderColor;
  final double indicatorBorderWidth;

  final double iconSize;
  final double iconLabelGap;
  final TextStyle labelStyle;

  /// Upper bound for system text scaling of labels, so large accessibility
  /// fonts do not overflow the fixed-height bar.
  final double maxLabelTextScale;

  /// Scale of an item while it is pressed.
  final double pressedScale;
  final Duration pressDuration;

  /// Fade-in of the selection pill on the newly selected item.
  final Duration indicatorInDuration;

  /// Fade-out of the selection pill on the previously selected item.
  final Duration indicatorOutDuration;

  /// Starting scale of the selection pill when it appears.
  final double indicatorInScale;

  /// Light selection haptic on tap.
  final bool enableHaptics;

  double get resolvedTrailingWidth => trailingWidth ?? height;

  // ── Per-item resolution ───────────────────────────────────────────────────

  Color selectedColorFor(FloatingNavItemStyle? s) =>
      s?.selectedColor ?? selectedColor;

  Color unselectedColorFor(FloatingNavItemStyle? s) =>
      s?.unselectedColor ?? unselectedColor;

  Color indicatorColorFor(FloatingNavItemStyle? s) =>
      s?.indicatorColor ?? indicatorColor;

  Color indicatorBorderColorFor(FloatingNavItemStyle? s) =>
      s?.indicatorBorderColor ?? indicatorBorderColor;

  TextStyle labelStyleFor(FloatingNavItemStyle? s) =>
      s?.labelStyle == null ? labelStyle : labelStyle.merge(s!.labelStyle);

  double iconSizeFor(FloatingNavItemStyle? s) => s?.iconSize ?? iconSize;

  FloatingNavBarStyle copyWith({
    EdgeInsets? margin,
    double? minBottomSpacing,
    double? homeIndicatorSpacing,
    double? height,
    EdgeInsets? padding,
    double? trailingGap,
    double? trailingWidth,
    Color? backgroundColor,
    BoxBorder? border,
    List<BoxShadow>? shadows,
    double? blurSigma,
    Color? selectedColor,
    Color? unselectedColor,
    Color? indicatorColor,
    Color? indicatorBorderColor,
    double? indicatorBorderWidth,
    double? iconSize,
    double? iconLabelGap,
    TextStyle? labelStyle,
    double? maxLabelTextScale,
    double? pressedScale,
    Duration? pressDuration,
    Duration? indicatorInDuration,
    Duration? indicatorOutDuration,
    double? indicatorInScale,
    bool? enableHaptics,
  }) {
    return FloatingNavBarStyle(
      margin: margin ?? this.margin,
      minBottomSpacing: minBottomSpacing ?? this.minBottomSpacing,
      homeIndicatorSpacing: homeIndicatorSpacing ?? this.homeIndicatorSpacing,
      height: height ?? this.height,
      padding: padding ?? this.padding,
      trailingGap: trailingGap ?? this.trailingGap,
      trailingWidth: trailingWidth ?? this.trailingWidth,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      border: border ?? this.border,
      shadows: shadows ?? this.shadows,
      blurSigma: blurSigma ?? this.blurSigma,
      selectedColor: selectedColor ?? this.selectedColor,
      unselectedColor: unselectedColor ?? this.unselectedColor,
      indicatorColor: indicatorColor ?? this.indicatorColor,
      indicatorBorderColor: indicatorBorderColor ?? this.indicatorBorderColor,
      indicatorBorderWidth: indicatorBorderWidth ?? this.indicatorBorderWidth,
      iconSize: iconSize ?? this.iconSize,
      iconLabelGap: iconLabelGap ?? this.iconLabelGap,
      labelStyle: labelStyle ?? this.labelStyle,
      maxLabelTextScale: maxLabelTextScale ?? this.maxLabelTextScale,
      pressedScale: pressedScale ?? this.pressedScale,
      pressDuration: pressDuration ?? this.pressDuration,
      indicatorInDuration: indicatorInDuration ?? this.indicatorInDuration,
      indicatorOutDuration: indicatorOutDuration ?? this.indicatorOutDuration,
      indicatorInScale: indicatorInScale ?? this.indicatorInScale,
      enableHaptics: enableHaptics ?? this.enableHaptics,
    );
  }

  @override
  bool operator ==(Object other) =>
      other is FloatingNavBarStyle &&
      other.margin == margin &&
      other.minBottomSpacing == minBottomSpacing &&
      other.homeIndicatorSpacing == homeIndicatorSpacing &&
      other.height == height &&
      other.padding == padding &&
      other.trailingGap == trailingGap &&
      other.trailingWidth == trailingWidth &&
      other.backgroundColor == backgroundColor &&
      other.border == border &&
      listEquals(other.shadows, shadows) &&
      other.blurSigma == blurSigma &&
      other.selectedColor == selectedColor &&
      other.unselectedColor == unselectedColor &&
      other.indicatorColor == indicatorColor &&
      other.indicatorBorderColor == indicatorBorderColor &&
      other.indicatorBorderWidth == indicatorBorderWidth &&
      other.iconSize == iconSize &&
      other.iconLabelGap == iconLabelGap &&
      other.labelStyle == labelStyle &&
      other.maxLabelTextScale == maxLabelTextScale &&
      other.pressedScale == pressedScale &&
      other.pressDuration == pressDuration &&
      other.indicatorInDuration == indicatorInDuration &&
      other.indicatorOutDuration == indicatorOutDuration &&
      other.indicatorInScale == indicatorInScale &&
      other.enableHaptics == enableHaptics;

  @override
  int get hashCode => Object.hashAll([
    margin,
    minBottomSpacing,
    homeIndicatorSpacing,
    height,
    padding,
    trailingGap,
    trailingWidth,
    backgroundColor,
    border,
    Object.hashAll(shadows),
    blurSigma,
    selectedColor,
    unselectedColor,
    indicatorColor,
    indicatorBorderColor,
    indicatorBorderWidth,
    iconSize,
    iconLabelGap,
    labelStyle,
    maxLabelTextScale,
    pressedScale,
    pressDuration,
    indicatorInDuration,
    indicatorOutDuration,
    indicatorInScale,
    enableHaptics,
  ]);
}
