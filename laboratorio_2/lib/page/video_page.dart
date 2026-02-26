import 'package:flutter/material.dart';
import '../models/movie.dart';

class VideoPage extends StatelessWidget {
  final Movie movie;

  const VideoPage({Key? key, required this.movie}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(movie.title, style: const TextStyle(color: Colors.white)),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.play_circle_outline,
              color: Colors.white54,
              size: 100,
            ),
            const SizedBox(height: 20),
            Text(
              'Reproductor de Video\n(Próximamente)',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey[400], fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
