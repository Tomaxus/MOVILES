import 'package:flutter/material.dart';

// Define el estilo general para mantener una UI consistente.
class TemaApp {
  // Tema claro principal usado por toda la aplicacion.
  static final ThemeData claro = ThemeData(
    useMaterial3: true,
    // Colores base del sistema de diseno.
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFF0F766E),
      surface: const Color(0xFFF8FAFC),
    ),
    scaffoldBackgroundColor: const Color(0xFFF8FAFC),
    // Jerarquia tipografica para titulos y textos comunes.
    textTheme: const TextTheme(
      headlineLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.w700),
      headlineMedium: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
      bodyLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
    ),
    // Estilo estandar de campos de entrada.
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    ),
    // Estilo estandar para botones elevados.
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 18),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
    ),
  );
}
