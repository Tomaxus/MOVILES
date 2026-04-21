import 'package:flutter/material.dart';

// Boton base de la app con soporte de estado cargando.
class BotonPrincipal extends StatelessWidget {
  // Texto que aparece dentro del boton.
  final String etiqueta;
  // Callback que se ejecuta al presionar.
  final VoidCallback? alPresionar;
  // Cuando es true, desactiva boton y muestra spinner.
  final bool cargando;

  const BotonPrincipal({
    super.key,
    required this.etiqueta,
    this.alPresionar,
    this.cargando = false,
  });

  @override
  Widget build(BuildContext context) {
    // SizedBox fuerza ancho completo para uniformidad visual.
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        // Bloqueamos la accion cuando hay una operacion en curso.
        onPressed: cargando ? null : alPresionar,
        child: cargando
            // Indicador pequeno para feedback inmediato al usuario.
            ? const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : Text(etiqueta),
      ),
    );
  }
}
