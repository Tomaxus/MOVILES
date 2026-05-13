import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/personaje.dart';

class DetallesPersonaje extends StatelessWidget {
  final Personaje personaje;

  const DetallesPersonaje({super.key, required this.personaje});

  Color get _estadoColor {
    if (personaje.estado == 'Alive') return Colors.greenAccent;
    if (personaje.estado == 'Dead') return Colors.redAccent;
    return Colors.grey;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(20),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 420),
        decoration: BoxDecoration(
          color: const Color(0xFF0D1F16), // fondo sólido
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.cyanAccent, width: 2),
          boxShadow: [
            BoxShadow(
              color: Colors.cyanAccent.withOpacity(.25),
              blurRadius: 20,
              spreadRadius: 2,
            ),
          ],
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(22),
                ),
                child: Image.network(
                  personaje.imagen,
                  height: 260,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    height: 260,
                    color: Colors.black26,
                    child: const Icon(
                      Icons.person,
                      size: 80,
                      color: Colors.white54,
                    ),
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  children: [
                    Text(
                      personaje.nombre,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.bungee(
                        fontSize: 22,
                        color: Colors.white,
                        height: 1.2,
                      ),
                    ),

                    const SizedBox(height: 18),

                    _filaEstado(),
                    _fila('Especie', personaje.especie),
                    _fila('Género', personaje.genero),
                    _fila('Origen', personaje.origen),
                    _fila('Ubicación', personaje.ubicacion),

                    const SizedBox(height: 22),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.cyanAccent,
                          foregroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: const Text(
                          'Cerrar',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _fila(String titulo, String valor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$titulo: ',
            style: const TextStyle(
              color: Colors.cyanAccent,
              fontWeight: FontWeight.bold,
            ),
          ),
          Expanded(
            child: Text(valor, style: const TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _filaEstado() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          const Text(
            'Estado: ',
            style: TextStyle(
              color: Colors.cyanAccent,
              fontWeight: FontWeight.bold,
            ),
          ),
          Container(
            width: 10,
            height: 10,
            margin: const EdgeInsets.only(right: 8),
            decoration: BoxDecoration(
              color: _estadoColor,
              shape: BoxShape.circle,
            ),
          ),
          Text(
            personaje.estado,
            style: TextStyle(color: _estadoColor, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
