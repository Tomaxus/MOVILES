import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../core/config/configuracion_api.dart';
import '../models/resultado_autenticacion.dart';

class ApiAutenticacion {
  final String urlBase;
  final http.Client _cliente;

  ApiAutenticacion({String? urlBase, http.Client? cliente})
    : urlBase = urlBase ?? ConfiguracionApi.urlBase,
      _cliente = cliente ?? http.Client();

  Future<ResultadoAutenticacion> registrar(
    String usuario,
    String contrasena,
  ) async {
    final uri = Uri.parse('$urlBase/register');
    try {
      final response = await _cliente.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'usuario': usuario, 'contrasena': contrasena}),
      );

      if (response.statusCode == 201) {
        return ResultadoAutenticacion.exito(_leerMensaje(response.body));
      }

      return ResultadoAutenticacion.fallo(_leerMensaje(response.body));
    } catch (_) {
      return const ResultadoAutenticacion(
        exito: false,
        mensaje: 'No se pudo conectar al servidor',
      );
    }
  }

  Future<ResultadoAutenticacion> iniciarSesion(
    String usuario,
    String contrasena,
  ) async {
    final uri = Uri.parse('$urlBase/login');
    try {
      final response = await _cliente.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'usuario': usuario, 'contrasena': contrasena}),
      );

      if (response.statusCode == 200) {
        final data = _leerJson(response.body);
        return ResultadoAutenticacion.exito(
          _leerMensaje(response.body),
          usuario: data['usuario']?.toString() ?? usuario,
        );
      }

      return ResultadoAutenticacion.fallo(_leerMensaje(response.body));
    } catch (_) {
      return const ResultadoAutenticacion(
        exito: false,
        mensaje: 'No se pudo conectar al servidor',
      );
    }
  }

  String _leerMensaje(String body) {
    final data = _leerJson(body);
    return data['mensaje']?.toString() ??
        data['message']?.toString() ??
        'Error en el servidor';
  }

  Map<String, dynamic> _leerJson(String body) {
    try {
      return jsonDecode(body) as Map<String, dynamic>;
    } catch (_) {
      return {};
    }
  }
}
