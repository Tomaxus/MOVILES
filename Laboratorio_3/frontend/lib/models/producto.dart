class Producto {
  final int id;
  final String nombre;
  final double calificacion;
  final String descripcion;
  final int existencias;
  final String imagen;

  const Producto({
    required this.id,
    required this.nombre,
    required this.calificacion,
    required this.descripcion,
    required this.existencias,
    required this.imagen,
  });

  factory Producto.fromJson(Map<String, dynamic> json) {
    return Producto(
      id: json['id'] as int,
      nombre: (json['nombre'] ?? '') as String,
      calificacion: (json['calificacion'] as num?)?.toDouble() ?? 0,
      descripcion: (json['descripcion'] ?? '') as String,
      existencias: (json['stok'] as num?)?.toInt() ?? 0,
      imagen: (json['imagen'] ?? '') as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'calificacion': calificacion,
      'descripcion': descripcion,
      'stok': existencias,
      'imagen': imagen,
    };
  }
}
