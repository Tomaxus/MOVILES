import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../models/producto.dart';

class ServicioNotificaciones {
  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  Future<void> inicializar() async {
    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    const settings = InitializationSettings(android: androidSettings);
    await _plugin.initialize(settings);

    final androidPlugin = _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    await androidPlugin?.requestNotificationsPermission();
  }

  Future<void> mostrarStockBajo(Producto producto) async {
    const androidDetails = AndroidNotificationDetails(
      'low_stock_channel',
      'Stock bajo',
      importance: Importance.max,
      priority: Priority.high,
    );

    const details = NotificationDetails(android: androidDetails);

    await _plugin.show(
      producto.id,
      'Atencion! Stock bajo',
      'Solo quedan ${producto.existencias} unidades de ${producto.nombre}',
      details,
    );
  }
}
