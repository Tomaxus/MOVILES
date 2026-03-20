import 'package:flutter/foundation.dart';

import '../models/producto.dart';
import '../services/servicio_api.dart';

class ProveedorProductos extends ChangeNotifier {
  final ServicioApi servicioApi;

  ProveedorProductos({required this.servicioApi});

  final List<Producto> _productos = [];
  bool _cargando = false;
  bool _cargandoMas = false;
  bool _tieneMas = true;
  int _pagina = 1;
  String? _error;

  List<Producto> get productos => _productos;
  bool get cargando => _cargando;
  bool get cargandoMas => _cargandoMas;
  bool get tieneMas => _tieneMas;
  String? get error => _error;

  Future<void> cargarInicial() async {
    if (_cargando) return;
    _cargando = true;
    _error = null;
    _pagina = 1;
    _tieneMas = true;
    _productos.clear();
    notifyListeners();

    try {
      final items = await servicioApi.obtenerProductos(pagina: _pagina);
      _productos.addAll(items);
      _tieneMas = items.length == 10;
      _pagina = 2;
    } catch (e) {
      _error = e.toString();
    } finally {
      _cargando = false;
      notifyListeners();
    }
  }

  Future<void> cargarMas() async {
    if (_cargandoMas || !_tieneMas) return;
    _cargandoMas = true;
    _error = null;
    notifyListeners();

    try {
      final items = await servicioApi.obtenerProductos(pagina: _pagina);
      _productos.addAll(items);
      _tieneMas = items.length == 10;
      _pagina += 1;
    } catch (e) {
      _error = e.toString();
    } finally {
      _cargandoMas = false;
      notifyListeners();
    }
  }
}
