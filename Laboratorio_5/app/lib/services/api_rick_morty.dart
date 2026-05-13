import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/personaje.dart';

class ApiRickMorty {
  static const String _url = 'https://rickandmortyapi.com/api/character';

  Future<List<Personaje>> obtenerPersonajes() async {
    try {
      final response = await http.get(Uri.parse(_url));
      if (response.statusCode == 200) {
        final datos = jsonDecode(response.body);
        final lista = (datos['results'] as List)
            .map((p) => Personaje.fromJson(p))
            .toList();
        return lista;
      }
      throw Exception('Error: ${response.statusCode}');
    } catch (e) {
      throw Exception('Error de conectividad: $e');
    }
  }

  Future<List<Personaje>> obtenerPorPagina(int pagina) async {
    try {
      final response = await http.get(Uri.parse('$_url?page=$pagina'));
      if (response.statusCode == 200) {
        final datos = jsonDecode(response.body);
        final lista = (datos['results'] as List)
            .map((p) => Personaje.fromJson(p))
            .toList();
        return lista;
      }
      throw Exception('Error: ${response.statusCode}');
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
