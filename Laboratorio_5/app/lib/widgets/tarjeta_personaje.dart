import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/personaje.dart';

class TarjetaPersonaje extends StatefulWidget {
  final Personaje personaje;
  final VoidCallback? alPresionar;

  const TarjetaPersonaje({
    super.key,
    required this.personaje,
    this.alPresionar,
  });

  @override
  State<TarjetaPersonaje> createState() => _TarjetaPersonajeState();
}

class _TarjetaPersonajeState extends State<TarjetaPersonaje> {
  bool _hover = false;

  bool get _vivo => widget.personaje.estado == 'Alive';
  bool get _muerto => widget.personaje.estado == 'Dead';

  Color get _colorEstado {
    if (_vivo) return Colors.greenAccent;
    if (_muerto) return Colors.redAccent;
    return Colors.grey;
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: GestureDetector(
        onTap: widget.alPresionar,
        child: AnimatedScale(
          scale: _hover ? 1.03 : 1,
          duration: const Duration(milliseconds: 200),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 400),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(22),
              gradient: RadialGradient(
                center: Alignment.topLeft,
                radius: 1.3,
                colors: [
                  Colors.cyanAccent.withOpacity(.18),
                  Colors.green.withOpacity(.12),
                  Colors.black87,
                ],
              ),
              border: Border.all(
                color: Colors.cyanAccent.withOpacity(.7),
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.cyanAccent.withOpacity(.18),
                  blurRadius: 18,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: Column(
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                    child: Image.network(
                      widget.personaje.imagen,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        color: Colors.grey[300],
                        child: const Icon(Icons.person, size: 70),
                      ),
                    ),
                  ),
                ),

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 10,
                  ),
                  child: Column(
                    children: [
                      Text(
                        widget.personaje.nombre,
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.visible,
                        style: GoogleFonts.bungee(
                          fontSize: 16,
                          height: 1.15,
                          color: Colors.white,
                          letterSpacing: 1,
                          shadows: const [
                            Shadow(blurRadius: 10, color: Colors.cyanAccent),
                          ],
                        ),
                      ),

                      const SizedBox(height: 10),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 12,
                            height: 12,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: _colorEstado,
                              boxShadow: [
                                BoxShadow(
                                  color: _colorEstado.withOpacity(.6),
                                  blurRadius: 8,
                                  spreadRadius: 1,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            widget.personaje.estado,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: _colorEstado,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
