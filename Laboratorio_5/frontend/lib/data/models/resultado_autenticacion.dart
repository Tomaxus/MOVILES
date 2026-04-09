class ResultadoAutenticacion {
  final bool exito;
  final String mensaje;
  final String? usuario;

  const ResultadoAutenticacion({
    required this.exito,
    required this.mensaje,
    this.usuario,
  });

  factory ResultadoAutenticacion.exito(String mensaje, {String? usuario}) {
    return ResultadoAutenticacion(
      exito: true,
      mensaje: mensaje,
      usuario: usuario,
    );
  }

  factory ResultadoAutenticacion.fallo(String mensaje) {
    return ResultadoAutenticacion(exito: false, mensaje: mensaje);
  }
}
