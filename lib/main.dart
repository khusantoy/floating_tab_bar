import 'package:flutter/material.dart';

import 'src/navigation/home_shell.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorSchemeSeed: const Color(0xFF405F8F)),
      home: const HomeShell(),
    );
  }
}
