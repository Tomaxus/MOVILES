import 'package:shared_preferences/shared_preferences.dart';

class ConfigApi {
  static const _claveIp = 'api_host';
  static const _clavePuerto = 'api_port';

  static String ip = '192.168.1.52';
  static int puerto = 3000;
  static SharedPreferences? _prefs;

  static String get urlBase => 'http://$ip:$puerto/api';

  static Future<void> cargar() async {
    _prefs = await SharedPreferences.getInstance();
    ip = _prefs?.getString(_claveIp) ?? ip;
    puerto = _prefs?.getInt(_clavePuerto) ?? puerto;
  }

  static Future<void> guardar({
    required String nuevaIp,
    required int nuevoPuerto,
  }) async {
    ip = nuevaIp.trim();
    puerto = nuevoPuerto;
    await _prefs?.setString(_claveIp, ip);
    await _prefs?.setInt(_clavePuerto, puerto);
  }
}
