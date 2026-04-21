import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../core/config/configuracion_api.dart';
import '../models/resultado_autenticacion.dart';

// Servicio que encapsula todas las llamadas HTTP del modulo de autenticacion.
class ApiAutenticacion {
  // Base URL configurable para conectar con el backend correcto.
  final String urlBase;
  // Cliente HTTP inyectable para facilitar pruebas.
  final http.Client _cliente;

  ApiAutenticacion({String? urlBase, http.Client? cliente})
    : urlBase = urlBase ?? ConfiguracionApi.urlBase,
      _cliente = cliente ?? http.Client();

  // Envia datos de registro y devuelve un resultado uniforme para UI.
  Future<ResultadoAutenticacion> registrar(
    String usuario,
    String contrasena, {
    required bool biometriaHabilitada,
  }) async {
    final uri = Uri.parse('$urlBase/register');
    try {
      // Peticion POST con body JSON esperado por el backend.
      final response = await _cliente.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'usuario': usuario,
          'contrasena': contrasena,
          'biometriaHabilitada': biometriaHabilitada,
        }),
      );

      // 201 indica registro exitoso.
      if (response.statusCode == 201) {
        return ResultadoAutenticacion.exito(_leerMensaje(response.body));
      }

      // Otros codigos regresan mensaje de error del servidor.
      return ResultadoAutenticacion.fallo(_leerMensaje(response.body));
    } catch (_) {
      // Si no hay red o backend caido, devolvemos error legible.
      return const ResultadoAutenticacion(
        exito: false,
        mensaje: 'No se pudo conectar al servidor',
      );
    }
  }

  // Envia credenciales para login y arma respuesta compatible con la vista.
  Future<ResultadoAutenticacion> iniciarSesion(
    String usuario,
    String contrasena,
  ) async {
    final uri = Uri.parse('$urlBase/login');
    try {
      // Misma estructura JSON para mantener consistencia con el backend.
      final response = await _cliente.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'usuario': usuario, 'contrasena': contrasena}),
      );

      // 200 significa autenticacion correcta.
      if (response.statusCode == 200) {
        final data = _leerJson(response.body);
        return ResultadoAutenticacion.exito(
          _leerMensaje(response.body),
          // Si el backend no manda usuario, usamos el ingresado.
          usuario: data['usuario']?.toString() ?? usuario,
          biometriaHabilitada: data['biometriaHabilitada'] == true,
        );
      }

      // Login fallido con mensaje del backend.
      return ResultadoAutenticacion.fallo(_leerMensaje(response.body));
    } catch (_) {
      // Error de red o conexion.
      return const ResultadoAutenticacion(
        exito: false,
        mensaje: 'No se pudo conectar al servidor',
      );
    }
  }

  // Extrae mensaje priorizando diferentes claves posibles del backend.
  String _leerMensaje(String body) {
    final data = _leerJson(body);
    return data['mensaje']?.toString() ??
        data['message']?.toString() ??
        'Error en el servidor';
  }

  // Convierte body JSON a mapa; si falla, retorna mapa vacio seguro.
  Map<String, dynamic> _leerJson(String body) {
    try {
      return jsonDecode(body) as Map<String, dynamic>;
    } catch (_) {
      return {};
    }
  }
}
