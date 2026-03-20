import 'package:flutter/foundation.dart';

import '../models/producto.dart';
import '../services/servicio_notificaciones.dart';

class ItemCarrito {
  final Producto producto;
  int cantidad;

  ItemCarrito({required this.producto, required this.cantidad});
}

class ProveedorCarrito extends ChangeNotifier {
  final ServicioNotificaciones servicioNotificaciones;

  ProveedorCarrito({required this.servicioNotificaciones});

  final Map<int, ItemCarrito> _articulos = {};

  List<ItemCarrito> get articulos => _articulos.values.toList();
  int get totalArticulos =>
      _articulos.values.fold(0, (sum, item) => sum + item.cantidad);

  void agregarProducto(Producto producto) {
    final existente = _articulos[producto.id];
    if (existente == null) {
      _articulos[producto.id] = ItemCarrito(producto: producto, cantidad: 1);
    } else {
      existente.cantidad += 1;
    }

    if (producto.existencias < 5) {
      servicioNotificaciones.mostrarStockBajo(producto);
    }

    notifyListeners();
  }

  void incrementar(Producto producto) {
    agregarProducto(producto);
  }

  void disminuir(Producto producto) {
    final existente = _articulos[producto.id];
    if (existente == null) return;

    if (existente.cantidad <= 1) {
      _articulos.remove(producto.id);
    } else {
      existente.cantidad -= 1;
    }

    notifyListeners();
  }

  void quitar(Producto producto) {
    _articulos.remove(producto.id);
    notifyListeners();
  }

  void limpiar() {
    _articulos.clear();
    notifyListeners();
  }
}
