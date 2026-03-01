import 'package:flutter/material.dart';
import '../models/movie.dart';
import '../page/video_page.dart';

// Tarjeta visual de cada película en el grid
class MovieCard extends StatelessWidget {
  final Movie movie; // película que va a mostrar esta tarjeta

  const MovieCard({Key? key, required this.movie}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Detecta cuando el usuario toca la tarjeta
    return GestureDetector(
      onTap: () {
        // Abre la pantalla del video pasando la película seleccionada
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => VideoPage(movie: movie)),
        );
      },

      child: Container(
        // Bordes redondeados y sombra debajo de la tarjeta
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: const Color.fromARGB(255, 122, 122, 122).withAlpha(100),
              blurRadius: 10,
            ),
          ],
        ),

        // ClipRRect recorta el contenido para que respete los bordes redondeados
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),

          child: Stack(
            fit: StackFit.expand,
            children: [
              // Imagen de portada cargada desde internet
              Image.network(
                movie.imageUrl,
                // la imagen cubre toda la tarjeta sin deformarse
                fit: BoxFit.cover,
                // Si la imagen falla al cargar, muestra un ícono de película
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey[800],
                    child: const Icon(
                      Icons.movie,
                      color: Colors.white54,
                      size: 50,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
