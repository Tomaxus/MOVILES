import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/movie.dart';

class MovieService {
  static const _endpoint = 'https://devsapihub.com/api-movies';

  static Future<List<Movie>> fetchMovies({int page = 1}) async {
    final url = '$_endpoint?page=$page&limit=10';
    final res = await http.get(Uri.parse(url));

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
