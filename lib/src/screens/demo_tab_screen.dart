import 'package:flutter/material.dart';

/// Placeholder tab: a long list so the bar floats over scrolling content.
class DemoTabScreen extends StatelessWidget {
  const DemoTabScreen({super.key, required this.title, required this.color});

  final String title;
  final MaterialColor color;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      // The outer Scaffold (extendBody: true) puts the bar height into
      // MediaQuery.padding.bottom, so the last item clears the bar.
      body: ListView.separated(
        padding: EdgeInsets.fromLTRB(
          16,
          8,
          16,
          16 + MediaQuery.paddingOf(context).bottom,
        ),
        itemCount: 20,
        separatorBuilder: (_, _) => const SizedBox(height: 12),
        itemBuilder: (context, i) => Container(
          height: 88,
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(width: 1, color: Colors.grey),
          ),
          child: Text(
            '$title ${i + 1}',
            style: const TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
