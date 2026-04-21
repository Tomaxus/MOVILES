import 'package:flutter/material.dart';

// Pantalla simple que confirma inicio de sesion exitoso.
class PaginaBienvenida extends StatelessWidget {
  // Nombre del usuario para personalizar el mensaje.
  final String usuario;

  const PaginaBienvenida({super.key, required this.usuario});

  @override
  Widget build(BuildContext context) {
    // Vista centrada con icono, usuario y mensaje de estado.
    return Scaffold(
      appBar: AppBar(title: const Text('Bienvenido')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.verified_rounded, size: 56),
            const SizedBox(height: 12),
            Text(usuario, style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 12),
            const Text('Sesion iniciada'),
          ],
        ),
      ),
    );
  }
}
