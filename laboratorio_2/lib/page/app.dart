import 'package:flutter/material.dart';
import '../data/movie-service.dart';
import '../models/movie.dart';
import '../design/movie-card.dart';

class AppScreen extends StatefulWidget {
  const AppScreen({Key? key}) : super(key: key);

  @override
  _AppScreenState createState() => _AppScreenState();
}

class _AppScreenState extends State<AppScreen> {
  List<Movie> _allMovies = [];
  List<Movie> _displayedMovies = [];

  int _currentPage = 1;
  final int _itemsPerPage = 4;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAllMovies();
  }

  Future<void> _loadAllMovies() async {
    try {
      final movies = await MovieService.fetchAllMovies();
      setState(() {
        _allMovies = movies;
        _isLoading = false;
        _updateDisplayedMovies(1);
      });
    } catch (e) {
      debugPrint("Error: $e");
      setState(() => _isLoading = false);
    }
  }

  void _updateDisplayedMovies(int page) {
    int startIndex = (page - 1) * _itemsPerPage;
    int endIndex = startIndex + _itemsPerPage;

    if (endIndex > _allMovies.length) {
      endIndex = _allMovies.length;
    }

    setState(() {
      _currentPage = page;
      _displayedMovies = _allMovies.sublist(startIndex, endIndex);
    });
  }

  int get _totalPages => (_allMovies.length / _itemsPerPage).ceil();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'PrimePeroNo',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: _isLoading
                ? const Center(
                    child: CircularProgressIndicator(color: Colors.blueAccent),
                  )
                : _displayedMovies.isEmpty
                ? const Center(child: Text('No hay películas.'))
                : GridView.builder(
                    padding: const EdgeInsets.all(16),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.65,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                        ),
                    itemCount: _displayedMovies.length,
                    itemBuilder: (context, index) {
                      return MovieCard(movie: _displayedMovies[index]);
                    },
                  ),
          ),

          Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFF1E1E1E),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.5),
                  blurRadius: 4,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.chevron_left, size: 35),
                  color: _currentPage > 1 ? Colors.white : Colors.grey[800],
                  onPressed: _currentPage > 1
                      ? () => _updateDisplayedMovies(_currentPage - 1)
                      : null,
                ),
                const SizedBox(width: 24),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.blueAccent,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '$_currentPage / $_totalPages',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 24),
                IconButton(
                  icon: const Icon(Icons.chevron_right, size: 35),
                  color: _currentPage < _totalPages
                      ? Colors.white
                      : Colors.grey[800],
                  onPressed: _currentPage < _totalPages
                      ? () => _updateDisplayedMovies(_currentPage + 1)
                      : null,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
