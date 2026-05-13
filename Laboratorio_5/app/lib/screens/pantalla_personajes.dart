import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/personaje.dart';
import '../services/api_rick_morty.dart';
import 'widget_grid_personajes.dart';
import 'detalles_personaje.dart';

class ListaPersonajes extends StatefulWidget {
  const ListaPersonajes({super.key});

  @override
  State<ListaPersonajes> createState() => _ListaPersonajesState();
}

class _ListaPersonajesState extends State<ListaPersonajes> {
  final ApiRickMorty _api = ApiRickMorty();

  late Future<List<Personaje>> _futuro;
  int _pagina = 1;

  static const _verde1 = Color(0xFF0F2E1B);
  static const _verde2 = Color(0xFF1E5A35);
  static const _verde3 = Color(0xFF8CFFD0);
  static const _cyan = Color(0xFF00F5FF);

  @override
  void initState() {
    super.initState();
    _cargar();
  }

  void _cargar() {
    _futuro = _api.obtenerPorPagina(_pagina);
  }

  void _cambiarPagina(int valor) {
    setState(() {
      _pagina += valor;
      _cargar();
    });
  }

  void _abrirDetalle(Personaje personaje) {
    showDialog(
      context: context,
      builder: (_) => DetallesPersonaje(personaje: personaje),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [_verde1, _verde2, _verde3],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: _appBar(),
        body: Column(
          children: [
            Expanded(
              child: FutureBuilder<List<Personaje>>(
                future: _futuro,
                builder: (_, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(color: _cyan),
                    );
                  }

                  if (snapshot.hasError) {
                    return _mensaje(
                      Icons.error_outline,
                      'Error al cargar personajes',
                      Colors.redAccent,
                    );
                  }

                  final personajes = snapshot.data ?? [];

                  if (personajes.isEmpty) {
                    return _mensaje(
                      Icons.person_off,
                      'No hay personajes',
                      Colors.white70,
                    );
                  }

                  return WidgetGridPersonajes(
                    personajes: personajes,
                    alPresionar: _abrirDetalle,
                  );
                },
              ),
            ),

            _paginacion(),
          ],
        ),
      ),
    );
  }

  Widget _paginacion() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 4, 12, 12),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed: _pagina > 1 ? () => _cambiarPagina(-1) : null,
              style: _boton(),
              child: const Text('Anterior'),
            ),
          ),

          Container(
            margin: const EdgeInsets.symmetric(horizontal: 10),
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: _cyan),
              color: Colors.black26,
            ),
            child: Text(
              'Página $_pagina',
              style: const TextStyle(color: _cyan, fontWeight: FontWeight.bold),
            ),
          ),

          Expanded(
            child: ElevatedButton(
              onPressed: () => _cambiarPagina(1),
              style: _boton(),
              child: const Text('Siguiente'),
            ),
          ),
        ],
      ),
    );
  }

  ButtonStyle _boton() {
    return ElevatedButton.styleFrom(
      backgroundColor: _verde1,
      foregroundColor: _cyan,
      padding: const EdgeInsets.symmetric(vertical: 14),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
    );
  }

  Widget _mensaje(IconData icono, String texto, Color color) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icono, size: 55, color: color),
          const SizedBox(height: 12),
          Text(
            texto,
            style: TextStyle(color: color, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  AppBar _appBar() {
    return AppBar(
      elevation: 0,
      centerTitle: true,
      backgroundColor: Colors.transparent,
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(colors: [_verde1, _verde2]),
        ),
      ),
      title: ShaderMask(
        shaderCallback: (bounds) => const LinearGradient(
          colors: [_verde3, _cyan, _verde3],
        ).createShader(bounds),
        child: Text(
          'RICK AND MORTY',
          style: GoogleFonts.bungee(
            fontSize: 28,
            color: Colors.white,
            letterSpacing: 2,
          ),
        ),
      ),
    );
  }
}
