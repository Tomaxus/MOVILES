// Permite convertir datos JSON
import 'dart:convert';

// Paquete para hacer peticiones HTTP que se utiliza para el get de la API
import 'package:http/http.dart' as http;

// Importa el modelo Movie para convertir el JSON en objetos de Movie
import '../models/movie.dart';

// Clase encargada de comunicarse con la API de películas
class MovieService {
  static const _endpoint = 'https://devsapihub.com/api-movies/limit/20';

  // Método estático que obtiene todas las películas de la API
  static Future<List<Movie>> fetchAllMovies() async {
    // Realiza la petición GET a la API y el await espera a que termine la petición antes de continuar
    final res = await http.get(Uri.parse(_endpoint));

    // Verifica que la respuesta sea exitosa (200 = OK)
    if (res.statusCode != 200) {
      // Si esto falla lanza un error
      throw Exception('Error al cargar películas');
    }

    // Convierte el cuerpo de la respuesta
    // en un objeto Dart (Map o List)
    final body = json.decode(res.body);

    // Se declara una variable tipo Iterable para almacenar la lista final
    Iterable list;

    // Si el JSON viene directamente como una lista:
    // [ {movie1}, {movie2} ]
    if (body is List) {
      list = body;

      // Si el JSON viene dentro de una clave "data":
      // { "data": [ {movie1}, {movie2} ] }
    } else if (body is Map && body.containsKey('data')) {
      list = body['data'];

      // Si el JSON viene dentro de una clave "results":
      // { "results": [ {movie1}, {movie2} ] }
    } else if (body is Map && body.containsKey('results')) {
      list = body['results'];

      // Si no coincide con ninguno de los casos anteriores
      // se evita el error devolviendo lista vacía
    } else {
      list = [];
    }

    // Convierte cada elemento JSON en un objeto Movie
    // map recorre cada elemento
    // Movie.fromJson(model) lo transforma en objeto Movie
    // toList() convierte el resultado en List<Movie>
    return list.map((model) => Movie.fromJson(model)).toList();
  }
}
