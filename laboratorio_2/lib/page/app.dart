import 'package:flutter/material.dart';
import '../data/movieservice.dart';
import '../models/movie.dart';
import '../design/movie-card.dart';

// Pantalla principal — es Stateful porque carga datos y maneja paginación
class AppScreen extends StatefulWidget {
  const AppScreen({Key? key}) : super(key: key);

  @override
  _AppScreenState createState() => _AppScreenState();
}

class _AppScreenState extends State<AppScreen> {
  //todas las movies obtenidas de la API
  List<Movie> _allMovies = [];
  // movies que se muestran en la página actual
  List<Movie> _displayedMovies = [];
  // pagina actual
  int _currentPage = 1;
  //cantidad de movies
  final int _itemsPerPage = 4;
  bool _isLoading = true;

  // Crear el estado inicial de la pantalla y cargar las películas al iniciar la app
  @override
  void initState() {
    super.initState();
    _loadAllMovies();
  }

  // Pide las películas a la API y las guarda en _allMovies
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

  // Calcula qué películas mostrar según la página seleccionada
  void _updateDisplayedMovies(int page) {
    //primera película de la página =
    int startIndex = (page - 1) * _itemsPerPage;
    // última película de la página
    int endIndex = startIndex + _itemsPerPage; // índice de fin

    // Evita pasarse del límite de la lista
    if (endIndex > _allMovies.length) endIndex = _allMovies.length;

    setState(() {
      _currentPage = page;
      _displayedMovies = _allMovies.sublist(startIndex, endIndex);
    });
  }

  // Total de páginas
  int get _totalPages => (_allMovies.length / _itemsPerPage).ceil();

  // Decide qué mostrar: spinner, mensaje o el grid
  Widget _buildContent() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          color: Color.fromARGB(255, 255, 255, 255),
        ),
      );
    }
    if (_displayedMovies.isEmpty) {
      return const Center(child: Text('No hay películas.'));
    }
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      // SliverGridDelegateWithFixedCrossAxisCount es para hacer el grid
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // 2 columnas
        childAspectRatio: 0.70, // proporción alto/ancho de cada tarjeta
        crossAxisSpacing: 16, // espacio horizontal entre tarjetas
        mainAxisSpacing: 16, // espacio vertical entre tarjetas
      ),
      // cantidad de elementos a mostrar (4 por página)
      itemCount: _displayedMovies.length,
      // Construye una MovieCard por cada película de la página
      itemBuilder: (context, index) =>
          MovieCard(movie: _displayedMovies[index]),
    );
  }

  // Construye la barra inferior de paginación con los botones anterior y siguiente
  Widget _buildPaginationBar() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 3),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 61, 61, 61),
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
          // si estás en la página 1, está deshabilitado
          IconButton(
            icon: const Icon(Icons.chevron_left, size: 35),
            color: _currentPage > 1 ? Colors.white : Colors.grey[800],
            onPressed: _currentPage > 1
                ? () => _updateDisplayedMovies(_currentPage - 1)
                : null,
          ),

          const SizedBox(width: 24),

          // Muestra la página actual y el total: "2 / 5"
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 51, 51, 51),
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

          // si estás en la última página, está deshabilitado (gris)
          IconButton(
            icon: const Icon(Icons.chevron_right, size: 35),
            color: _currentPage < _totalPages ? Colors.white : Colors.grey[800],
            onPressed: _currentPage < _totalPages
                ? () => _updateDisplayedMovies(_currentPage + 1)
                : null,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Barra superior con el nombre de la app
      appBar: AppBar(
        title: const Text(
          'PrimePeroNo',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),

      // Cuerpo: grid arriba y barra de paginación abajo
      body: Column(
        children: [
          Expanded(child: _buildContent()), // spinner, mensaje o grid
          _buildPaginationBar(), // barra con botones de pagina
        ],
      ),
    );
  }
}
