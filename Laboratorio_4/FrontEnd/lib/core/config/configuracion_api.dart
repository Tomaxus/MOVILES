import 'dart:io';

import 'package:flutter/foundation.dart';

class ConfiguracionApi {
  static const String urlBaseEntorno = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: '',
  );

  static String get urlBase {
    if (urlBaseEntorno.isNotEmpty) {
      return urlBaseEntorno;
    }
    if (kIsWeb) {
      return 'http://localhost:3000';
    }
    if (Platform.isAndroid) {
      return 'http://10.0.2.2:3000';
    }
    if (Platform.isIOS) {
      return 'http://localhost:3000';
    }
    return 'http://localhost:3000';
  }
}
