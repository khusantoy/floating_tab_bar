import 'package:floating_nav_bar/floating_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Bottom navigation destinations of the app, in Figma order.
abstract final class AppTabs {
  static const items = [
    FloatingNavItem(
      label: 'Asosiy',
      icon: _SvgIcon('assets/icons/home.svg'),
      activeIcon: _SvgIcon('assets/icons/home_filled.svg'),
    ),
    FloatingNavItem(
      label: 'Kabinet',
      icon: _SvgIcon('assets/icons/user.svg'),
      activeIcon: _SvgIcon('assets/icons/user_filled.svg'),
    ),
    FloatingNavItem(
      label: 'Sozlamalar',
      icon: _SvgIcon('assets/icons/setting.svg'),
      activeIcon: _SvgIcon('assets/icons/setting_filled.svg'),
    ),
  ];

  static const _exchangeRed = Color(0xFFAB3A3A);

  /// 3D artwork from Figma. Always the 4x file (96px for a 24pt icon), scaled
  /// down on every screen, so the artwork stays sharp.
  static const _exchangeIcon = 'assets/icons/4.0x/birja.png';

  /// Detached "Birja" item with its own colors.
  static const trailing = FloatingNavItem(
    label: 'Birja',
    icon: Image(
      image: ExactAssetImage(_exchangeIcon, scale: 4),
      fit: BoxFit.contain,
      filterQuality: FilterQuality.medium,
    ),
    style: FloatingNavItemStyle(
      backgroundColor: Color(0xFFFCF5F4),
      selectedColor: _exchangeRed,
      unselectedColor: _exchangeRed,
      // No selection pill: the button already has its own background.
      indicatorColor: Color(0x00000000),
      indicatorBorderColor: Color(0x00000000),
    ),
  );
}

/// Single-color Figma SVG tinted with the bar's animated [IconTheme] color,
/// so it behaves like an [Icon] (including the outline/filled cross-fade).
class _SvgIcon extends StatelessWidget {
  const _SvgIcon(this.asset);

  final String asset;

  @override
  Widget build(BuildContext context) {
    final theme = IconTheme.of(context);
    return SvgPicture.asset(
      asset,
      width: theme.size,
      height: theme.size,
      colorFilter: ColorFilter.mode(theme.color!, BlendMode.srcIn),
    );
  }
}
