// Modelo que representa una película
class Movie {
  // Atributos de la clase
  final int id;
  final String title;
  final String description;
  final int year;
  final String imageUrl;
  final String genre;
  final double stars;

  // Constructor principal
  Movie({
    required this.id,
    required this.title,
    required this.description,
    required this.year,
    required this.imageUrl,
    required this.genre,
    required this.stars,
  });

  // Constructor factory para crear una instancia
  factory Movie.fromJson(Map<String, dynamic> json) {
    // Retorna una nueva instancia de Movie
    return Movie(
      // Toma el valor del JSON.
      // Si viene null, usa 0 como valor por defecto
      id: json['id'] ?? 0,

      // Si el título no existe, coloca "Sin título"
      title: json['title'] ?? 'Sin título',

      // Si no hay descripción, coloca texto por defecto
      description: json['description'] ?? 'Sin descripción',

      // Si el año no viene en el JSON, usa 0
      year: json['year'] ?? 0,

      // Nota: en el JSON viene como "image_url"
      // pero en Dart usamos camelCase: imageUrl
      imageUrl: json['image_url'] ?? '',

      // Si no hay género, coloca "Desconocido"
      genre: json['genre'] ?? 'Desconocido',

      // Si es null usa 0 y luego lo convierte a double
      stars: (json['stars'] ?? 0).toDouble(),
    );
  }
}
