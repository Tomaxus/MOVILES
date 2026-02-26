import 'package:flutter/material.dart';
import 'page/app.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Películas App',
      debugShowCheckedModeBanner: false, // Quita la cinta roja
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const AppScreen(),
    );
  }
}
