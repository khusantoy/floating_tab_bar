import 'package:flutter/widgets.dart';

import 'models/floating_nav_item.dart';
import 'styles/floating_nav_bar_style.dart';
import 'widgets/nav_bar_frame.dart';
import 'widgets/nav_bar_item_view.dart';
import 'widgets/nav_bar_surface.dart';

/// Floating bottom navigation bar with One UI style motion. Looks the same
/// on every platform.
///
/// The bar is controlled: it shows [selectedIndex] and reports taps through
/// [onTap] without changing the selection itself. Indices run over [items]
/// first, then [trailingItem] (index `items.length`). [onTap] also fires for
/// the already selected item, e.g. to scroll a tab back to the top.
///
/// Place it in `Scaffold.bottomNavigationBar` with `extendBody: true` so the
/// content scrolls behind the bar and `MediaQuery.padding.bottom` of the body
/// accounts for the bar height.
class FloatingNavBar extends StatelessWidget {
  const FloatingNavBar({
    super.key,
    required this.items,
    this.trailingItem,
    required this.selectedIndex,
    required this.onTap,
    this.style = const FloatingNavBarStyle(),
  }) : assert(items.length > 0, 'items must not be empty');

  /// Items inside the main bar.
  final List<FloatingNavItem> items;

  /// Optional detached item shown to the right of the main bar.
  final FloatingNavItem? trailingItem;

  final int selectedIndex;
  final ValueChanged<int> onTap;
  final FloatingNavBarStyle style;

  @override
  Widget build(BuildContext context) {
    final trailing = trailingItem;
    return NavBarFrame(
      style: style,
      // Isolates the bar's animations from the scrolling content behind it.
      child: RepaintBoundary(
        child: MediaQuery.withClampedTextScaling(
          maxScaleFactor: style.maxLabelTextScale,
          child: Row(
            children: [
              Expanded(
                child: NavBarSurface(
                  style: style,
                  color: style.backgroundColor,
                  child: Row(
                    children: [
                      for (var i = 0; i < items.length; i++)
                        Expanded(child: _item(items[i], i)),
                    ],
                  ),
                ),
              ),
              if (trailing != null) ...[
                SizedBox(width: style.trailingGap),
                SizedBox(
                  width: style.resolvedTrailingWidth,
                  child: NavBarSurface(
                    style: style,
                    color:
                        trailing.style?.backgroundColor ??
                        style.backgroundColor,
                    child: _item(trailing, items.length),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _item(FloatingNavItem item, int index) {
    return NavBarItemView(
      item: item,
      selected: index == selectedIndex,
      style: style,
      onTap: () => onTap(index),
    );
  }
}
