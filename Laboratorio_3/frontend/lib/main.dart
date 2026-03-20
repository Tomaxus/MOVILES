import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/proveedor_carrito.dart';
import 'providers/proveedor_productos.dart';
import 'screens/pantalla_inicio.dart';
import 'services/configuracion_api.dart';
import 'services/servicio_api.dart';
import 'services/servicio_notificaciones.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await ConfigApi.cargar();

  final servicioNotificaciones = ServicioNotificaciones();
  await servicioNotificaciones.inicializar();

  runApp(Aplicacion(servicioNotificaciones: servicioNotificaciones));
}

class Aplicacion extends StatelessWidget {
  final ServicioNotificaciones servicioNotificaciones;

  const Aplicacion({super.key, required this.servicioNotificaciones});

  @override
  Widget build(BuildContext context) {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: const Color(0xFF0EA5A4),
      brightness: Brightness.light,
      primary: const Color(0xFF0EA5A4),
      secondary: const Color(0xFFF97316),
      surface: const Color(0xFFF8FAFC),
    );

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ProveedorProductos(servicioApi: ServicioApi()),
        ),
        ChangeNotifierProvider(
          create: (_) =>
              ProveedorCarrito(servicioNotificaciones: servicioNotificaciones),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Store UPB',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: colorScheme,
          scaffoldBackgroundColor: const Color(0xFFF8FAFC),
          appBarTheme: AppBarTheme(
            backgroundColor: colorScheme.surface,
            elevation: 0,
            centerTitle: false,
            titleTextStyle: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: Color(0xFF0F172A),
            ),
          ),
          cardTheme: CardThemeData(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            color: Colors.white,
          ),
        ),
        home: const PantallaInicio(),
      ),
    );
  }
}
