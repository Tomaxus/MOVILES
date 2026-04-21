import 'package:flutter/material.dart';

import '../core/theme/tema_app.dart';
import '../features/auth/pagina_autenticacion.dart';

// Widget raiz que configura tema, titulo y pantalla inicial.
class Aplicacion extends StatelessWidget {
  const Aplicacion({super.key});

  @override
  Widget build(BuildContext context) {
    // MaterialApp concentra la configuracion global de navegacion y estilo.
    return MaterialApp(
      title: 'Acceso',
      debugShowCheckedModeBanner: false,
      theme: TemaApp.claro,
      // Comenzamos en la pantalla de autenticacion.
      home: const PaginaAutenticacion(),
    );
  }
}
