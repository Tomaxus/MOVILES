import 'package:flutter/material.dart';

class BotonPrincipal extends StatelessWidget {
  final String etiqueta;
  final VoidCallback? alPresionar;
  final bool cargando;

  const BotonPrincipal({
    super.key,
    required this.etiqueta,
    this.alPresionar,
    this.cargando = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: cargando ? null : alPresionar,
        child: cargando
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
