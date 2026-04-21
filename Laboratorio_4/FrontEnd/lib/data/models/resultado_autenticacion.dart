// Modelo simple para comunicar exito/error entre API y pantalla.
class ResultadoAutenticacion {
  // Indica si la operacion fue exitosa.
  final bool exito;
  // Mensaje para mostrar al usuario.
  final String mensaje;
  // Username opcional que retorna el backend al iniciar sesion.
  final String? usuario;
  // Flag para conocer si el usuario habilito login por huella.
  final bool biometriaHabilitada;

  const ResultadoAutenticacion({
    required this.exito,
    required this.mensaje,
    this.usuario,
    this.biometriaHabilitada = false,
  });

  // Constructor de conveniencia para casos exitosos.
  factory ResultadoAutenticacion.exito(
    String mensaje, {
    String? usuario,
    bool biometriaHabilitada = false,
  }) {
    return ResultadoAutenticacion(
      exito: true,
      mensaje: mensaje,
      usuario: usuario,
      biometriaHabilitada: biometriaHabilitada,
    );
  }

  // Constructor de conveniencia para casos de error.
  factory ResultadoAutenticacion.fallo(String mensaje) {
    return ResultadoAutenticacion(exito: false, mensaje: mensaje);
  }
}
