import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/producto.dart';
import '../providers/proveedor_carrito.dart';

class PantallaDetalle extends StatelessWidget {
  final Producto producto;

  const PantallaDetalle({super.key, required this.producto});

  @override
  Widget build(BuildContext context) {
    final carrito = context.read<ProveedorCarrito>();

    return Scaffold(
      appBar: AppBar(title: Text(producto.nombre)),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Hero(
            tag: 'producto_${producto.id}',
            child: ClipRRect(
              borderRadius: BorderRadius.circular(28),
              child: CachedNetworkImage(
                imageUrl: producto.imagen,
                height: 280,
                fit: BoxFit.cover,
                placeholder: (context, _) =>
                    Container(color: const Color(0xFFE2E8F0)),
                errorWidget: (context, _, __) =>
                    const Icon(Icons.broken_image, size: 48),
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            producto.nombre,
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.star, color: Color(0xFFF59E0B)),
              const SizedBox(width: 6),
              Text(
                '${producto.calificacion}',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFE0F2FE),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text('Stock: ${producto.existencias}'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            producto.descripcion,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(height: 1.6),
          ),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: () {
              carrito.agregarProducto(producto);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Producto agregado al carrito')),
              );
            },
            icon: const Icon(Icons.add_shopping_cart),
            label: const Text('Agregar al carrito'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
