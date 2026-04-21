import 'dart:io';

import 'package:flutter/foundation.dart';

// Centraliza la URL del backend segun entorno y plataforma.
class ConfiguracionApi {
  // IP local del host (ajusta si cambia la red Wi-Fi).
  static const String _ipHost = '192.168.1.52';
  // Permite inyectar URL desde --dart-define en compilacion.
  static const String urlBaseEntorno = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: '',
  );

  static String get urlBase {
    // Si viene una URL externa, esa tiene prioridad total.
    if (urlBaseEntorno.isNotEmpty) {
      return urlBaseEntorno;
    }
    // En web se usa localhost directo del host.
    if (kIsWeb) {
      return 'http://$_ipHost:3000';
    }
    // En Android emulator, 10.0.2.2 apunta al localhost de la maquina.
    if (Platform.isAndroid) {
      return 'http://$_ipHost:3000';
    }
    // En iOS simulator localhost suele resolver al host local.
    if (Platform.isIOS) {
      return 'http://$_ipHost:3000';
    }
    // Fallback para escritorio u otras plataformas.
    return 'http://$_ipHost:3000';
  }
}
