import 'package:flutter/physics.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../models/floating_nav_item.dart';
import '../styles/floating_nav_bar_style.dart';

/// One tab of the Flutter bar.
///
/// Motion (modelled on the One UI floating tab bar):
/// * press: the whole item (pill included) shrinks while the finger is down
///   and springs back on release. A quick tap still plays one full pulse.
/// * selection: the pill does not slide between tabs. It fades and scales in
///   on the new tab while the old one fades out.
///
/// Only transforms and opacity are animated, so no frame triggers a layout.
class NavBarItemView extends StatefulWidget {
  const NavBarItemView({
    super.key,
    required this.item,
    required this.selected,
    required this.style,
    required this.onTap,
  });

  final FloatingNavItem item;
  final bool selected;
  final FloatingNavBarStyle style;
  final VoidCallback onTap;

  @override
  State<NavBarItemView> createState() => _NavBarItemViewState();
}

class _NavBarItemViewState extends State<NavBarItemView>
    with TickerProviderStateMixin {
  /// Slightly under-damped, so the release overshoots a touch past 1.0.
  static const _releaseSpring = SpringDescription(
    mass: 1,
    stiffness: 420,
    damping: 24,
  );

  late final AnimationController _selection = AnimationController(
    vsync: this,
    value: widget.selected ? 1 : 0,
    duration: widget.style.indicatorInDuration,
    reverseDuration: widget.style.indicatorOutDuration,
  );

  late final CurvedAnimation _selectionCurve = CurvedAnimation(
    parent: _selection,
    curve: Curves.easeOutCubic,
    reverseCurve: Curves.easeInCubic,
  );

  /// 0 = rest, 1 = fully pressed. Unbounded so the release spring can
  /// overshoot.
  late final AnimationController _press = AnimationController.unbounded(
    vsync: this,
  );

  bool _pointerDown = false;

  @override
  void didUpdateWidget(NavBarItemView oldWidget) {
    super.didUpdateWidget(oldWidget);
    _selection
      ..duration = widget.style.indicatorInDuration
      ..reverseDuration = widget.style.indicatorOutDuration;
    if (widget.selected != oldWidget.selected) {
      widget.selected ? _selection.forward() : _selection.reverse();
    }
  }

  @override
  void dispose() {
    _selectionCurve.dispose();
    _selection.dispose();
    _press.dispose();
    super.dispose();
  }

  // ── Gestures ──────────────────────────────────────────────────────────────

  void _handleTapDown(TapDownDetails _) {
    _pointerDown = true;
    _press.animateTo(
      1,
      duration: widget.style.pressDuration,
      curve: Curves.easeOut,
    );
  }

  void _handleTapUp(TapUpDetails _) => _release();

  void _handleTapCancel() => _release();

  void _handleTap() {
    if (widget.style.enableHaptics) HapticFeedback.selectionClick();
    widget.onTap();
  }

  void _release() {
    _pointerDown = false;
    if (_press.value >= 1) return _springBack();
    // The finger lifted before the press-in finished: complete it first so
    // every tap produces one visible pulse.
    final remaining = widget.style.pressDuration * (1 - _press.value);
    _press.animateTo(1, duration: remaining, curve: Curves.easeOut).then((_) {
      if (mounted && !_pointerDown) _springBack();
    });
  }

  void _springBack() {
    _press.animateWith(
      SpringSimulation(_releaseSpring, _press.value, 0, _press.velocity),
    );
  }

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final style = widget.style;
    final itemStyle = widget.item.style;

    return Semantics(
      container: true,
      button: true,
      selected: widget.selected,
      label: widget.item.semanticLabel ?? widget.item.label,
      excludeSemantics: true,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: _handleTapDown,
        onTapUp: _handleTapUp,
        onTapCancel: _handleTapCancel,
        onTap: _handleTap,
        child: ScaleTransition(
          scale: _press.drive(Tween(begin: 1, end: style.pressedScale)),
          child: Stack(
            fit: StackFit.expand,
            children: [
              _SelectionPill(
                animation: _selectionCurve,
                inScale: style.indicatorInScale,
                color: style.indicatorColorFor(itemStyle),
                borderColor: style.indicatorBorderColorFor(itemStyle),
                borderWidth: style.indicatorBorderWidth,
              ),
              Center(
                child: _ItemContent(
                  item: widget.item,
                  style: style,
                  selection: _selectionCurve,
                  selected: widget.selected,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SelectionPill extends StatelessWidget {
  const _SelectionPill({
    required this.animation,
    required this.inScale,
    required this.color,
    required this.borderColor,
    required this.borderWidth,
  });

  final Animation<double> animation;
  final double inScale;
  final Color color;
  final Color borderColor;
  final double borderWidth;

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: animation,
      child: ScaleTransition(
        scale: animation.drive(Tween(begin: inScale, end: 1)),
        child: DecoratedBox(
          decoration: ShapeDecoration(
            color: color,
            shape: StadiumBorder(
              side: borderWidth > 0
                  ? BorderSide(color: borderColor, width: borderWidth)
                  : BorderSide.none,
            ),
          ),
        ),
      ),
    );
  }
}

class _ItemContent extends StatelessWidget {
  const _ItemContent({
    required this.item,
    required this.style,
    required this.selection,
    required this.selected,
  });

  final FloatingNavItem item;
  final FloatingNavBarStyle style;
  final Animation<double> selection;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final itemStyle = item.style;
    final selectedColor = style.selectedColorFor(itemStyle);
    final unselectedColor = style.unselectedColorFor(itemStyle);
    final iconSize = style.iconSizeFor(itemStyle);
    final labelStyle = style.labelStyleFor(itemStyle);

    return AnimatedBuilder(
      animation: selection,
      builder: (context, _) {
        final t = selection.value;
        final color = Color.lerp(unselectedColor, selectedColor, t)!;
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox.square(
              dimension: iconSize,
              child: IconTheme.merge(
                data: IconThemeData(color: color, size: iconSize),
                child: _buildIcon(context, color, t),
              ),
            ),
            SizedBox(height: style.iconLabelGap),
            // Narrow items (many tabs, small screens, large text) shrink the
            // label to fit instead of cutting it off.
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                item.label,
                maxLines: 1,
                softWrap: false,
                textAlign: TextAlign.center,
                style: labelStyle.copyWith(color: color),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildIcon(BuildContext context, Color color, double t) {
    final builder = item.iconBuilder;
    if (builder != null) return builder(context, color, selected);

    final icon = item.icon!;
    final activeIcon = item.activeIcon;
    if (activeIcon == null) return icon;
    if (t <= 0) return icon;
    if (t >= 1) return activeIcon;
    // Cross-fade between the outline and the filled glyph.
    return Stack(
      fit: StackFit.expand,
      children: [
        Opacity(opacity: 1 - t, child: icon),
        Opacity(opacity: t, child: activeIcon),
      ],
    );
  }
}
