import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/proveedor_carrito.dart';
import '../providers/proveedor_productos.dart';
import '../services/configuracion_api.dart';
import '../services/servicio_api.dart';
import '../widgets/insignia_carrito.dart';
import '../widgets/rejilla_brillo.dart';
import '../widgets/tarjeta_producto.dart';
import 'pantalla_carrito.dart';

class PantallaInicio extends StatefulWidget {
  const PantallaInicio({super.key});

  @override
  State<PantallaInicio> createState() => _PantallaInicioState();
}

class _PantallaInicioState extends State<PantallaInicio> {
  bool _bienvenidaProgramada = false;

  Future<void> _mostrarDialogoBienvenida() async {
    if (!mounted) return;

    await showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Bienvenido'),
          content: const Text('Aqui estan los mejores productos'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Entendido'),
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProveedorProductos>().cargarInicial();
    });

    if (!_bienvenidaProgramada) {
      _bienvenidaProgramada = true;
      Future.delayed(const Duration(minutes: 1), () {
        _mostrarDialogoBienvenida();
      });
    }
  }

  bool _manejarScroll(ScrollNotification notification) {
    if (notification.metrics.pixels >=
        notification.metrics.maxScrollExtent - 300) {
      context.read<ProveedorProductos>().cargarMas();
    }
    return false;
  }

  Future<void> _abrirConfiguracionServidor() async {
    final hostController = TextEditingController(text: ConfigApi.ip);
    final portController = TextEditingController(
      text: ConfigApi.puerto.toString(),
    );
    final formKey = GlobalKey<FormState>();

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          ),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Configurar servidor',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: hostController,
                  decoration: const InputDecoration(
                    labelText: 'IP del servidor',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Ingresa una IP valida';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: portController,
                  decoration: const InputDecoration(
                    labelText: 'Puerto',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    final parsed = int.tryParse(value ?? '');
                    if (parsed == null || parsed <= 0) {
                      return 'Ingresa un puerto valido';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (!formKey.currentState!.validate()) {
                        return;
                      }

                      final nuevaIp = hostController.text.trim();
                      final nuevoPuerto = int.parse(portController.text.trim());

                      await ConfigApi.guardar(
                        nuevaIp: nuevaIp,
                        nuevoPuerto: nuevoPuerto,
                      );

                      try {
                        await ServicioApi().obtenerProductos(pagina: 1);
                        if (!mounted) return;
                        Navigator.of(context).pop();
                        if (!mounted) return;
                        context.read<ProveedorProductos>().cargarInicial();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Conexion exitosa')),
                        );
                      } catch (_) {
                        if (!mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('No se pudo conectar al servidor'),
                          ),
                        );
                      }
                    },
                    child: const Text('Probar y guardar'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final carrito = context.watch<ProveedorCarrito>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Store UPB'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: _abrirConfiguracionServidor,
          ),
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: InsigniaCarrito(
              count: carrito.totalArticulos,
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const PantallaCarrito()),
                );
              },
            ),
          ),
        ],
      ),
      body: NotificationListener<ScrollNotification>(
        onNotification: _manejarScroll,
        child: Consumer<ProveedorProductos>(
          builder: (context, proveedor, _) {
            if (proveedor.cargando && proveedor.productos.isEmpty) {
              return const RejillaBrillo();
            }

            if (proveedor.error != null && proveedor.productos.isEmpty) {
              return Center(
                child: Text(
                  'No se pudo cargar el catalogo',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              );
            }

            return GridView.builder(
              padding: const EdgeInsets.all(20),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 18,
                crossAxisSpacing: 18,
                childAspectRatio: 0.7,
              ),
              itemCount:
                  proveedor.productos.length + (proveedor.tieneMas ? 1 : 0),
              itemBuilder: (context, index) {
                if (index >= proveedor.productos.length) {
                  return const Center(child: CircularProgressIndicator());
                }

                final producto = proveedor.productos[index];
                return TarjetaProducto(producto: producto);
              },
            );
          },
        ),
      ),
    );
  }
}
