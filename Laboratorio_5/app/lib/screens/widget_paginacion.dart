import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class WidgetPaginacion extends StatelessWidget {
  final int paginaActual;
  final VoidCallback alAnterior;
  final VoidCallback alSiguiente;

  const WidgetPaginacion({
    super.key,
    required this.paginaActual,
    required this.alAnterior,
    required this.alSiguiente,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: Colors.cyanAccent.withOpacity(0.3)),
        ),
        color: const Color(0xFF1A472A).withOpacity(0.05),
        boxShadow: [
          BoxShadow(
            color: Colors.cyanAccent.withOpacity(0.08),
            blurRadius: 16,
            spreadRadius: 2,
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _boton(
            etiqueta: '← Anterior',
            alPresionar: paginaActual > 1 ? alAnterior : null,
          ),
          const SizedBox(width: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFF1A472A).withOpacity(0.18),
              border: Border.all(
                color: Colors.cyanAccent.withOpacity(0.7),
                width: 2,
              ),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.cyanAccent.withOpacity(0.18),
                  blurRadius: 12,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: Text(
              'Página $paginaActual',
              style: GoogleFonts.bungee(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.cyanAccent,
                letterSpacing: 1.2,
                shadows: [
                  const Shadow(
                    blurRadius: 10,
                    color: Colors.cyanAccent,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 16),
          _boton(etiqueta: 'Siguiente →', alPresionar: alSiguiente),
        ],
      ),
    );
  }

  Widget _boton({
    required String etiqueta,
    required VoidCallback? alPresionar,
  }) {
    return ElevatedButton(
      onPressed: alPresionar,
      style: ElevatedButton.styleFrom(
        backgroundColor: alPresionar == null
            ? Colors.grey[300]
            : const Color(0xFF1A472A),
        foregroundColor: alPresionar == null
            ? Colors.grey[600]
            : Colors.cyanAccent,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 8,
        shadowColor: Colors.cyanAccent.withOpacity(0.3),
      ),
      child: Text(
        etiqueta,
        style: GoogleFonts.bungee(
          fontWeight: FontWeight.bold,
          fontSize: 16,
          letterSpacing: 1.1,
          shadows: [
            const Shadow(
              blurRadius: 8,
              color: Colors.cyanAccent,
              offset: Offset(0, 2),
            ),
          ],
        ),
      ),
    );
  }
}
