import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../core/widgets/boton_principal.dart';
import '../../core/widgets/campo_texto.dart';
import '../../data/api/api_autenticacion.dart';
import '../welcome/pagina_bienvenida.dart';

class PaginaAutenticacion extends StatefulWidget {
  const PaginaAutenticacion({super.key});

  @override
  State<PaginaAutenticacion> createState() => _PaginaAutenticacionState();
}

class _PaginaAutenticacionState extends State<PaginaAutenticacion> {
  final _usuario = TextEditingController();
  final _contrasena = TextEditingController();
  final _api = ApiAutenticacion();

  bool _esLogin = true;
  bool _cargando = false;
  bool _enLinea = false;
  bool _verificando = false;
  String? _error;
  StreamSubscription<List<ConnectivityResult>>? _suscripcion;

  @override
  void initState() {
    super.initState();
    _actualizarEstado();
    _suscripcion = Connectivity().onConnectivityChanged.listen(
      (_) => _actualizarEstado(),
    );
  }

  @override
  void dispose() {
    _suscripcion?.cancel();
    _usuario.dispose();
    _contrasena.dispose();
    super.dispose();
  }

  Future<void> _actualizarEstado() async {
    setState(() => _verificando = true);
    final ok = await _tieneInternet();
    if (!mounted) return;
    setState(() {
      _enLinea = ok;
      _verificando = false;
    });
  }

  Future<bool> _tieneInternet() async {
    final results = await Connectivity().checkConnectivity();
    if (results.contains(ConnectivityResult.none)) {
      return false;
    }
    if (kIsWeb) {
      return true;
    }
    try {
      final lookup = await InternetAddress.lookup('example.com');
      return lookup.isNotEmpty && lookup.first.rawAddress.isNotEmpty;
    } catch (_) {
      return false;
    }
  }

  Widget _estadoInternet() {
    final color = _enLinea ? const Color(0xFF16A34A) : const Color(0xFFDC2626);
    final label = _enLinea ? 'En linea' : 'Sin conexion';

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (_verificando)
          const SizedBox(
            width: 14,
            height: 14,
            child: CircularProgressIndicator(strokeWidth: 2),
          )
        else
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
        const SizedBox(width: 8),
        Text(
          label,
          style: TextStyle(color: color, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }

  Future<void> _enviar() async {
    FocusScope.of(context).unfocus();
    final usuario = _usuario.text.trim();
    final contrasena = _contrasena.text.trim();

    if (usuario.isEmpty || contrasena.isEmpty) {
      setState(() => _error = 'Completa usuario y contrasena');
      return;
    }

    setState(() {
      _cargando = true;
      _error = null;
    });

    final resultado = _esLogin
        ? await _api.iniciarSesion(usuario, contrasena)
        : await _api.registrar(usuario, contrasena);

    if (!mounted) return;

    setState(() => _cargando = false);

    if (!resultado.exito) {
      setState(() => _error = resultado.mensaje);
      return;
    }

    if (_esLogin) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) =>
              PaginaBienvenida(usuario: resultado.usuario ?? usuario),
        ),
      );
    } else {
      setState(() => _esLogin = true);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(resultado.mensaje)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_esLogin ? 'Iniciar sesion' : 'Crear cuenta'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: _estadoInternet(),
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            Text(
              _esLogin ? 'Accede para continuar' : 'Registra tus datos',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 20),
            CampoTexto(controlador: _usuario, etiqueta: 'Usuario'),
            const SizedBox(height: 12),
            CampoTexto(
              controlador: _contrasena,
              etiqueta: 'Contrasena',
              oculto: true,
            ),
            if (_error != null) ...[
              const SizedBox(height: 12),
              Text(
                _error!,
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            ],
            const SizedBox(height: 16),
            BotonPrincipal(
              etiqueta: _esLogin ? 'Entrar' : 'Registrar',
              cargando: _cargando,
              alPresionar: _enviar,
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: _cargando
                  ? null
                  : () => setState(() => _esLogin = !_esLogin),
              child: Text(
                _esLogin
                    ? 'No tienes cuenta? Registrate'
                    : 'Ya tienes cuenta? Inicia sesion',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
