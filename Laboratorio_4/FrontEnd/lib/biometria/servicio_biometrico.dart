import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:local_auth/error_codes.dart' as auth_error;

import 'resultado_biometrico.dart';

// Encapsula toda la logica de huella/biometria en un solo lugar.
class ServicioBiometrico {
  // Cliente de local_auth para consultas y autenticacion.
  final LocalAuthentication _auth;

  ServicioBiometrico({LocalAuthentication? auth})
    : _auth = auth ?? LocalAuthentication();

  // Valida si el dispositivo soporta biometria y tiene una registrada.
  Future<bool> estaDisponible() async {
    final soporta = await _auth.isDeviceSupported();
    final puede = await _auth.canCheckBiometrics;
    return soporta && puede;
  }

  // Devuelve un nombre amigable para la biometria detectada.
  Future<String> etiquetaPreferida() async {
    try {
      final disponibles = await _auth.getAvailableBiometrics();
      if (disponibles.contains(BiometricType.fingerprint)) {
        return 'huella';
      }
      if (disponibles.contains(BiometricType.face)) {
        return 'rostro';
      }
      if (disponibles.contains(BiometricType.iris)) {
        return 'iris';
      }
    } catch (_) {
      // Si falla la consulta, usamos un texto generico.
    }
    return 'biometria';
  }

  // Ejecuta el flujo biometrico y estandariza el resultado.
  Future<ResultadoBiometrico> autenticar({required String motivo}) async {
    try {
      final ok = await _auth.authenticate(
        localizedReason: motivo,
        options: const AuthenticationOptions(
          biometricOnly: true,
          stickyAuth: true,
          useErrorDialogs: true,
        ),
      );

      if (ok) {
        return ResultadoBiometrico.exito('Autenticacion biometrica exitosa');
      }

      return ResultadoBiometrico.fallo('Autenticacion biometrica cancelada');
    } on PlatformException catch (e) {
      // Traduccion usando codigos oficiales de local_auth.
      if (e.code == auth_error.notAvailable) {
        return ResultadoBiometrico.fallo('Biometria no disponible');
      }
      if (e.code == auth_error.notEnrolled) {
        return ResultadoBiometrico.fallo('No hay biometria registrada');
      }
      if (e.code == auth_error.lockedOut ||
          e.code == auth_error.permanentlyLockedOut) {
        return ResultadoBiometrico.fallo('Biometria bloqueada temporalmente');
      }
      if (e.code == auth_error.passcodeNotSet) {
        return ResultadoBiometrico.fallo(
          'Configura bloqueo de pantalla para usar biometria',
        );
      }
      return ResultadoBiometrico.fallo('No se pudo validar la biometria');
    } catch (_) {
      return ResultadoBiometrico.fallo('Error inesperado en biometria');
    }
  }
}
