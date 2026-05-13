class Personaje {
  final int id;
  final String nombre;
  final String estado;
  final String especie;
  final String genero;
  final String imagen;
  final String origen;
  final String ubicacion;

  Personaje({
    required this.id,
    required this.nombre,
    required this.estado,
    required this.especie,
    required this.genero,
    required this.imagen,
    required this.origen,
    required this.ubicacion,
  });

  factory Personaje.fromJson(Map<String, dynamic> json) {
    return Personaje(
      id: json['id'] ?? 0,
      nombre: json['name'] ?? 'Desconocido',
      estado: json['status'] ?? '',
      especie: json['species'] ?? '',
      genero: json['gender'] ?? '',
      imagen: json['image'] ?? '',
      origen: json['origin']?['name'] ?? 'Desconocido',
      ubicacion: json['location']?['name'] ?? 'Desconocido',
    );
  }
}
