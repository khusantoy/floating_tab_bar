import 'package:floating_nav_bar/floating_nav_bar.dart';
import 'package:floating_nav_bar/src/widgets/nav_bar_item_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

const _items = [
  FloatingNavItem(label: 'Home', icon: Icon(Icons.home)),
  FloatingNavItem(label: 'Profile', icon: Icon(Icons.person)),
  FloatingNavItem(label: 'Settings', icon: Icon(Icons.settings)),
];
const _trailing = FloatingNavItem(
  label: 'Exchange',
  icon: Icon(Icons.show_chart),
);
const _style = FloatingNavBarStyle(enableHaptics: false);

Widget _app({required int selected, ValueChanged<int>? onTap}) {
  return MaterialApp(
    home: Scaffold(
      extendBody: true,
      body: const SizedBox.expand(),
      bottomNavigationBar: FloatingNavBar(
        items: _items,
        trailingItem: _trailing,
        selectedIndex: selected,
        onTap: onTap ?? (_) {},
        style: _style,
      ),
    ),
  );
}

Finder _itemView(int index) => find.byType(NavBarItemView).at(index);

double _pillOpacity(WidgetTester tester, int index) {
  final fade = tester.widget<FadeTransition>(
    find
        .descendant(of: _itemView(index), matching: find.byType(FadeTransition))
        .first,
  );
  return fade.opacity.value;
}

double _pressScale(WidgetTester tester, int index) {
  final scale = tester.widget<ScaleTransition>(
    find
        .descendant(
          of: _itemView(index),
          matching: find.byType(ScaleTransition),
        )
        .first,
  );
  return scale.scale.value;
}

void main() {
  testWidgets('reports main and trailing indices', (tester) async {
    final taps = <int>[];
    await tester.pumpWidget(_app(selected: 0, onTap: taps.add));

    await tester.tap(find.text('Settings'));
    await tester.tap(find.text('Exchange'));
    await tester.tap(find.text('Home')); // re-tap of the selected item
    await tester.pumpAndSettle();

    expect(taps, [2, 3, 0]);
  });

  testWidgets('bar uses the Figma height', (tester) async {
    await tester.pumpWidget(_app(selected: 0));
    expect(tester.getSize(_itemView(0)).height, 56);
    expect(tester.getSize(_itemView(3)), const Size(56, 56));
  });

  testWidgets('pill fades in on the new item instead of sliding', (
    tester,
  ) async {
    await tester.pumpWidget(_app(selected: 0));
    expect(_pillOpacity(tester, 0), 1);
    expect(_pillOpacity(tester, 1), 0);

    await tester.pumpWidget(_app(selected: 1));
    await tester.pump(_style.indicatorOutDuration ~/ 2);
    final incoming = _pillOpacity(tester, 1);
    final outgoing = _pillOpacity(tester, 0);
    expect(incoming, inExclusiveRange(0, 1));
    expect(outgoing, inExclusiveRange(0, 1));

    await tester.pumpAndSettle();
    expect(_pillOpacity(tester, 1), 1);
    expect(_pillOpacity(tester, 0), 0);
  });

  testWidgets('item shrinks while pressed and springs back', (tester) async {
    await tester.pumpWidget(_app(selected: 0));

    final gesture = await tester.startGesture(
      tester.getCenter(find.text('Home')),
    );
    await tester.pump(); // ticker starts on the next frame
    await tester.pump(_style.pressDuration);
    expect(_pressScale(tester, 0), closeTo(_style.pressedScale, 0.001));

    await gesture.up();
    await tester.pumpAndSettle();
    expect(_pressScale(tester, 0), closeTo(1, 0.001));
  });

  testWidgets('a quick tap still plays one full press pulse', (tester) async {
    await tester.pumpWidget(_app(selected: 0));

    await tester.tap(find.text('Profile'));
    var minScale = 1.0;
    for (var i = 0; i < 30; i++) {
      await tester.pump(const Duration(milliseconds: 16));
      final scale = _pressScale(tester, 1);
      if (scale < minScale) minScale = scale;
    }
    expect(minScale, closeTo(_style.pressedScale, 0.01));

    await tester.pumpAndSettle();
    expect(_pressScale(tester, 1), closeTo(1, 0.001));
  });

  testWidgets('long labels scale down to fit four narrow tabs', (tester) async {
    tester.view.physicalSize = const Size(320, 640);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    const items = [
      FloatingNavItem(label: 'Asosiy', icon: Icon(Icons.home)),
      FloatingNavItem(label: 'Kabinet', icon: Icon(Icons.person)),
      FloatingNavItem(label: 'Xabarlar', icon: Icon(Icons.mail)),
      FloatingNavItem(label: 'Sozlamalar', icon: Icon(Icons.settings)),
    ];
    await tester.pumpWidget(
      MaterialApp(
        home: MediaQuery(
          data: const MediaQueryData(
            size: Size(320, 640),
            textScaler: TextScaler.linear(2),
          ),
          child: Scaffold(
            bottomNavigationBar: FloatingNavBar(
              items: items,
              trailingItem: _trailing,
              selectedIndex: 0,
              onTap: (_) {},
              style: _style,
            ),
          ),
        ),
      ),
    );

    expect(tester.takeException(), isNull);
    for (var i = 0; i < items.length; i++) {
      final label = find.text(items[i].label);
      final itemRect = tester.getRect(_itemView(i));
      final labelRect = tester.getRect(label);
      expect(labelRect.left, greaterThanOrEqualTo(itemRect.left - 0.01));
      expect(labelRect.right, lessThanOrEqualTo(itemRect.right + 0.01));
    }
    // The longest label is wider than its slot and was scaled down.
    expect(
      tester.getSize(find.text('Sozlamalar')).width,
      greaterThan(tester.getSize(find.byType(FittedBox).at(3)).width),
    );
  });

  group('bottom spacing', () {
    Future<double> gapBelowBar(WidgetTester tester) async {
      await tester.pumpWidget(
        MediaQuery(
          data: const MediaQueryData(
            size: Size(402, 874),
            padding: EdgeInsets.only(bottom: 34),
          ),
          child: _app(selected: 0),
        ),
      );
      final screen = tester.getRect(find.byType(Scaffold)).bottom;
      return screen -
          tester.getRect(_itemView(0)).bottom -
          _style.padding.bottom;
    }

    testWidgets('iOS sits closer to the home indicator', (tester) async {
      expect(await gapBelowBar(tester), _style.homeIndicatorSpacing);
    }, variant: TargetPlatformVariant.only(TargetPlatform.iOS));

    testWidgets('Android keeps the full bottom inset', (tester) async {
      expect(await gapBelowBar(tester), 34);
    }, variant: TargetPlatformVariant.only(TargetPlatform.android));
  });
}
