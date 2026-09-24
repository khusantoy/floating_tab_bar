# floating_nav_bar

Floating bottom navigation bar, pure Flutter, identical on every platform.

* Press: the tab (pill included) shrinks while held and springs back; a quick
  tap still plays one full pulse.
* Selection: the pill does not slide. It fades and scales in on the tapped
  tab while the old one fades out.
* Only transforms and opacity animate, inside a `RepaintBoundary`.

No third-party dependencies.

## Usage

```dart
Scaffold(
  extendBody: true, // content scrolls behind the bar
  body: IndexedStack(index: index, children: screens),
  bottomNavigationBar: FloatingNavBar(
    items: const [
      FloatingNavItem(
        label: 'Home',
        icon: Icon(Icons.home_outlined),
        activeIcon: Icon(Icons.home),
      ),
      // ...
    ],
    trailingItem: const FloatingNavItem(
      label: 'Exchange',
      icon: Image(image: AssetImage('assets/icons/exchange.png')),
    ),
    selectedIndex: index,
    onTap: (i) => setState(() => index = i),
    style: const FloatingNavBarStyle(), // colors, sizes, durations, haptics
  ),
)
```

* The bar is controlled: `onTap` reports taps (also re-taps) and the bar
  shows `selectedIndex`. Indices cover `items`, then `trailingItem`.
* `icon` / `activeIcon` are colored through `IconTheme`. For widgets that
  ignore it (e.g. `SvgPicture`) use `iconBuilder`, which receives the
  animated color.
* `FloatingNavItemStyle` overrides colors per item (e.g. a red trailing item).
