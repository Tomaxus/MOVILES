// Resultado simple para reportar exito o error en biometria.
class ResultadoBiometrico {
  // Indica si la validacion biometrica fue correcta.
  final bool exito;
  // Mensaje para UI o logs.
  final String mensaje;

  const ResultadoBiometrico({required this.exito, required this.mensaje});

  // Conveniencia para casos exitosos.
  factory ResultadoBiometrico.exito(String mensaje) {
    return ResultadoBiometrico(exito: true, mensaje: mensaje);
  }

  // Conveniencia para casos con error o cancelacion.
  factory ResultadoBiometrico.fallo(String mensaje) {
    return ResultadoBiometrico(exito: false, mensaje: mensaje);
  }
}
