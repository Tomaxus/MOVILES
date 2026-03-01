// Importa los widgets básicos de Flutter
import 'package:flutter/material.dart';

// Importa el reproductor de YouTube (paquete externo)
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

// Importa el modelo Movie para recibir los datos de la película
import '../models/movie.dart';

// VideoPage es un StatefulWidget porque necesita manejar estado ya que es el reproductor del video
class VideoPage extends StatefulWidget {
  // Recibe la película seleccionada desde la pantalla anterior
  final Movie movie;

  // Constructor que obliga a enviar la película
  const VideoPage({Key? key, required this.movie}) : super(key: key);

  // Crea el estado asociado a este widget
  @override
  _VideoPageState createState() => _VideoPageState();
}

// Logica y estado del VideoPage
class _VideoPageState extends State<VideoPage> {
  // Controlador que maneja el reproductor de YouTube
  late YoutubePlayerController _controller;

  // Key = id de la película
  // Value = id del video en YouTube
  final Map<int, String> _trailers = {
    1: '6hB3S9bIaco',
    2: 'rBxcF-r9Ibs',
    3: 'UaVTIH8mujA',
    4: '9O1Iy9od7-A',
    5: 'EXeTwQWrcwY',
    6: '_13J_9B5jEk',
    7: '7psP7xBEa28',
    8: 'y2rYRu8UW8M',
    9: 'TjhZuh-6MTQ',
    10: 'WCN5JJY_wiA',
    11: 'V75dSyZa9eQ',
    12: 'qtRKdVHc-cE',
    13: 'Way9Dexny3w',
    14: 'uYPbbksJxIg',
    15: 'pBk4NYhWNMM',
    16: 'JfVOs4VSpmA',
    17: 'd9MyW72ELq0',
    18: 'mqqft2x_Aa4',
    19: 'wxN1T1uxQ2g',
    20: 'vKQi3bBA1y8',
  };

  @override
  void initState() {
    super.initState();

    // Busca el trailer según el id de la película
    String youtubeVideoId = _trailers[widget.movie.id] ?? 'cvDxdUcxPUE';

    // Crea el reproductor con el video encontrado
    _controller = YoutubePlayerController.fromVideoId(
      videoId: youtubeVideoId,
      autoPlay: true,
      params: const YoutubePlayerParams(
        showControls: true,
        showFullscreenButton: false,
      ),
    );
  }

  // Se ejecuta cuando el widget se cierra
  @override
  void dispose() {
    _controller.close();
    super.dispose();
  }

  // Interfaz visual
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Fondo oscuro
      backgroundColor: const Color.fromARGB(255, 0, 0, 0),

      // Barra superior
      appBar: AppBar(
        title: Text(widget.movie.title, style: const TextStyle(fontSize: 16)),
        backgroundColor: const Color.fromARGB(255, 0, 0, 0),
      ),

      // Permite hacer scroll si el contenido es largo
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Contenedor del video
            Container(
              // todo el ancho que este disponible
              width: double.infinity,
              color: Colors.black,

              // Widget que muestra el reproductor de YouTube
              child: YoutubePlayer(controller: _controller),
            ),

            // Espaciado general del contenido
            Padding(
              padding: const EdgeInsets.all(17),

              child: Column(
                // esto es que alinee todo a la izquierda todos los hijos del column y start es el inicio del eje horizontal
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Título grande
                  Text(
                    widget.movie.title,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Fila con año, género y estrellas
                  Row(
                    children: [
                      // Año
                      Text(
                        '${widget.movie.year}',
                        style: TextStyle(color: Colors.grey[400], fontSize: 16),
                      ),

                      const SizedBox(width: 16),

                      // Género en una etiqueta
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.grey[800],
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          widget.movie.genre,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                          ),
                        ),
                      ),

                      const SizedBox(width: 16),

                      // Estrellas
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 20),
                          const SizedBox(width: 4),
                          Text(
                            '${widget.movie.stars}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Título sección Sinopsis
                  const Text(
                    'Sinopsis',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),

                  const SizedBox(height: 8),

                  // Descripción de la película
                  Text(
                    widget.movie.description,
                    style: const TextStyle(
                      fontSize: 15,
                      color: Colors.white70,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
