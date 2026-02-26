import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/movie.dart';

class MovieService {
  static const _endpoint = 'https://devsapihub.com/api-movies/limit/20';

  static Future<List<Movie>> fetchAllMovies() async {
    final res = await http.get(Uri.parse(_endpoint));

    if (res.statusCode != 200) {
      throw Exception('Error al cargar películas');
    }

    final body = json.decode(res.body);
    Iterable list;

    if (body is List) {
      list = body;
    } else if (body is Map && body.containsKey('data')) {
      list = body['data'];
    } else if (body is Map && body.containsKey('results')) {
      list = body['results'];
    } else {
      list = [];
    }

    return list.map((model) => Movie.fromJson(model)).toList();
  }
}
