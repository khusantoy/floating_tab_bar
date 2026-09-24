import 'package:floating_nav_bar/floating_nav_bar.dart';
import 'package:flutter/material.dart';

import '../screens/demo_tab_screen.dart';
import 'app_tabs.dart';

class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _index = 0;

  static const _screens = [
    DemoTabScreen(title: 'Asosiy', color: Colors.indigo),
    DemoTabScreen(title: 'Kabinet', color: Colors.teal),
    DemoTabScreen(title: 'Sozlamalar', color: Colors.blueGrey),
    DemoTabScreen(title: 'Birja', color: Colors.red),
  ];

  void _onTap(int index) {
    if (index == _index) return; // Re-tap: e.g. scroll the tab to top.
    setState(() => _index = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: IndexedStack(index: _index, children: _screens),
      bottomNavigationBar: FloatingNavBar(
        items: AppTabs.items,
        trailingItem: AppTabs.trailing,
        selectedIndex: _index,
        onTap: _onTap,
      ),
    );
  }
}
