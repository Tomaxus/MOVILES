import 'package:flutter/material.dart';

// Campo de texto reutilizable para no repetir configuracion en pantallas.
class CampoTexto extends StatelessWidget {
  // Controlador para leer/escribir el valor del input desde afuera.
  final TextEditingController controlador;
  // Texto visible arriba del campo.
  final String etiqueta;
  // Si es true, oculta caracteres (por ejemplo, contrasena).
  final bool oculto;
  // Permite elegir teclado segun tipo de dato.
  final TextInputType tipoTeclado;

  const CampoTexto({
    super.key,
    required this.controlador,
    required this.etiqueta,
    this.oculto = false,
    this.tipoTeclado = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    // Render simple del TextField con parametros configurables.
    return TextField(
      controller: controlador,
      obscureText: oculto,
      keyboardType: tipoTeclado,
      decoration: InputDecoration(labelText: etiqueta),
    );
  }
}
