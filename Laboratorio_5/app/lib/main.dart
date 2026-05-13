import 'package:flutter/material.dart';
import 'dynamic_ui.dart';

void main() {
  runApp(const MiApp());
}

class MiApp extends StatelessWidget {
  const MiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rick and Morty',
      theme: ThemeData(
        useMaterial3: true,
        primaryColor: const Color(0xFF1A472A),
      ),
      home: Scaffold(
        appBar: AppBar(title: const Text('UI Dinámica')),
        body: DynamicUI(jsonAssetPath: 'assets/ui_definition.json'),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
