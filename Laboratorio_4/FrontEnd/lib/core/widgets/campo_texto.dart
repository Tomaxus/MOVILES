import 'package:flutter/material.dart';

class CampoTexto extends StatelessWidget {
  final TextEditingController controlador;
  final String etiqueta;
  final bool oculto;
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
    return TextField(
      controller: controlador,
      obscureText: oculto,
      keyboardType: tipoTeclado,
      decoration: InputDecoration(labelText: etiqueta),
    );
  }
}
