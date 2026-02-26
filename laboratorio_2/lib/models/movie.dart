class Movie {
  final int id;
  final String title;
  final String description;
  final int year;
  final String imageUrl;
  final String genre;
  final double stars;

  Movie({
    required this.id,
    required this.title,
    required this.description,
    required this.year,
    required this.imageUrl,
    required this.genre,
    required this.stars,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json['id'] ?? 0,
      title: json['title'] ?? 'Sin título',
      description: json['description'] ?? 'Sin descripción',
      year: json['year'] ?? 0,
      imageUrl: json['image_url'] ?? '',
      genre: json['genre'] ?? 'Desconocido',
      stars: (json['stars'] ?? 0).toDouble(),
    );
  }
}
