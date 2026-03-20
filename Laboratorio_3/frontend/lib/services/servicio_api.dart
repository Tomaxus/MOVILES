import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/producto.dart';
import 'configuracion_api.dart';

class ServicioApi {
  final http.Client _cliente;

  ServicioApi({http.Client? cliente}) : _cliente = cliente ?? http.Client();

  Future<List<Producto>> obtenerProductos({
    required int pagina,
    int limite = 10,
  }) async {
    final uri = Uri.parse('${ConfigApi.urlBase}/productos?page=$pagina');
    final response = await _cliente.get(uri);

    if (response.statusCode != 200) {
      throw Exception('Error al cargar productos');
    }

    final data = jsonDecode(response.body) as List<dynamic>;
    return data
        .map((item) => Producto.fromJson(item as Map<String, dynamic>))
        .toList();
  }
}
