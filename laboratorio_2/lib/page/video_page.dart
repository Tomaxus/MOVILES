import 'package:flutter/material.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';
import '../models/movie.dart';

class VideoPage extends StatefulWidget {
  final Movie movie;

  const VideoPage({Key? key, required this.movie}) : super(key: key);

  @override
  _VideoPageState createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> {
  late YoutubePlayerController _controller;

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
    String youtubeVideoId = _trailers[widget.movie.id] ?? 'cvDxdUcxPUE';

    _controller = YoutubePlayerController.fromVideoId(
      videoId: youtubeVideoId,
      autoPlay: false,
      params: const YoutubePlayerParams(
        showControls: true,
        showFullscreenButton: true,
      ),
    );
  }

  @override
  void dispose() {
    _controller.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        title: Text(widget.movie.title, style: const TextStyle(fontSize: 16)),
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              color: Colors.black,
              child: YoutubePlayer(controller: _controller),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.movie.title,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Text(
                        '${widget.movie.year}',
                        style: TextStyle(color: Colors.grey[400], fontSize: 16),
                      ),
                      const SizedBox(width: 16),
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
                  const Text(
                    'Sinopsis',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
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
