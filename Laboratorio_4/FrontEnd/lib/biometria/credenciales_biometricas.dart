import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// Guarda y recupera credenciales para login biometrico local.
class CredencialesBiometricas {
  static const _prefijoContrasena = 'bio_contrasena_';

  // Usamos almacenamiento cifrado del sistema operativo.
  final FlutterSecureStorage _storage;

  CredencialesBiometricas({FlutterSecureStorage? storage})
    : _storage = storage ?? const FlutterSecureStorage();

  String _claveContrasenaPorUsuario(String usuario) {
    return '$_prefijoContrasena${usuario.toLowerCase()}';
  }

  // Persiste credenciales de un usuario para login posterior con huella.
  Future<void> guardar({
    required String usuario,
    required String contrasena,
  }) async {
    await _storage.write(
      key: _claveContrasenaPorUsuario(usuario),
      value: contrasena,
    );
  }

  // Informa si el usuario tiene credencial biometrica guardada.
  Future<bool> tieneCredenciales(String usuario) async {
    final contrasena = await _storage.read(
      key: _claveContrasenaPorUsuario(usuario),
    );
    return (contrasena ?? '').isNotEmpty;
  }

  // Recupera la contrasena de un usuario; retorna null si no existe.
  Future<String?> leerContrasena(String usuario) async {
    final contrasena = await _storage.read(
      key: _claveContrasenaPorUsuario(usuario),
    );

    if ((contrasena ?? '').isEmpty) {
      return null;
    }

    return contrasena;
  }

  // Limpia credencial local de un usuario cuando ya no es valida.
  Future<void> limpiar(String usuario) async {
    await _storage.delete(key: _claveContrasenaPorUsuario(usuario));
  }
}
