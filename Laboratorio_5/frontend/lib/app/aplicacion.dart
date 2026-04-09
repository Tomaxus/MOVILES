import 'package:flutter/material.dart';

import '../core/theme/tema_app.dart';
import '../features/auth/pagina_autenticacion.dart';

class Aplicacion extends StatelessWidget {
  const Aplicacion({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Acceso',
      debugShowCheckedModeBanner: false,
      theme: TemaApp.claro,
      home: const PaginaAutenticacion(),
    );
  }
}
