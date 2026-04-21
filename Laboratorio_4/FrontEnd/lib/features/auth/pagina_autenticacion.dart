import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../biometria/credenciales_biometricas.dart';
import '../../biometria/servicio_biometrico.dart';
import '../../core/widgets/boton_principal.dart';
import '../../core/widgets/campo_texto.dart';
import '../../data/api/api_autenticacion.dart';
import '../welcome/pagina_bienvenida.dart';

// Pantalla principal para registro/login y verificacion de conectividad.
class PaginaAutenticacion extends StatefulWidget {
  const PaginaAutenticacion({super.key});

  @override
  State<PaginaAutenticacion> createState() => _PaginaAutenticacionState();
}

class _PaginaAutenticacionState extends State<PaginaAutenticacion> {
  // Controladores de inputs para leer texto de usuario y contrasena.
  final _usuario = TextEditingController();
  final _contrasena = TextEditingController();
  // Cliente de autenticacion para hablar con el backend.
  final _api = ApiAutenticacion();
  // Servicio biometrico encapsulado en carpeta dedicada.
  final _biometria = ServicioBiometrico();
  // Almacen seguro para credenciales del login biometrico.
  final _credencialesBiometricas = CredencialesBiometricas();

  // Estado de la vista: modo, carga, red y mensajes.
  bool _esLogin = true;
  bool _cargando = false;
  bool _enLinea = false;
  bool _verificando = false;
  bool _biometriaDisponible = false;
  bool _autenticandoBiometria = false;
  String _etiquetaBiometria = 'biometria';
  String? _error;
  // Suscripcion para reaccionar a cambios de conectividad.
  StreamSubscription<List<ConnectivityResult>>? _suscripcion;

  @override
  void initState() {
    super.initState();
    // Revisamos internet al entrar y escuchamos cambios en tiempo real.
    _actualizarEstado();
    // Preparamos disponibilidad de huella/biometria en segundo plano.
    _cargarBiometria();
    _suscripcion = Connectivity().onConnectivityChanged.listen(
      (_) => _actualizarEstado(),
    );
  }

  @override
  void dispose() {
    // Limpieza de recursos para evitar fugas de memoria.
    _suscripcion?.cancel();
    _usuario.dispose();
    _contrasena.dispose();
    super.dispose();
  }

  // Actualiza indicadores visuales de conectividad en la UI.
  Future<void> _actualizarEstado() async {
    setState(() => _verificando = true);
    final ok = await _tieneInternet();
    if (!mounted) return;
    setState(() {
      _enLinea = ok;
      _verificando = false;
    });
  }

  // Consulta si hay biometria disponible y define etiqueta para la UI.
  Future<void> _cargarBiometria() async {
    final disponible = await _biometria.estaDisponible();
    final etiqueta = disponible
        ? await _biometria.etiquetaPreferida()
        : 'biometria';

    if (!mounted) return;
    setState(() {
      _biometriaDisponible = disponible;
      _etiquetaBiometria = etiqueta;
    });
  }

  // Confirma conexion combinando estado de red y verificacion real.
  Future<bool> _tieneInternet() async {
    final results = await Connectivity().checkConnectivity();
    if (results.contains(ConnectivityResult.none)) {
      return false;
    }
    // En web evitamos lookup DNS porque no aplica igual que en mobile/desktop.
    if (kIsWeb) {
      return true;
    }
    try {
      // Si resuelve dominio externo, asumimos internet disponible.
      final lookup = await InternetAddress.lookup('example.com');
      return lookup.isNotEmpty && lookup.first.rawAddress.isNotEmpty;
    } catch (_) {
      return false;
    }
  }

  // Widget pequeno para mostrar estado de internet en el AppBar.
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

  // Ejecuta login o registro segun modo actual de la pantalla.
  Future<void> _enviar() async {
    // Cerramos teclado para dejar visible feedback de la pantalla.
    FocusScope.of(context).unfocus();
    final usuario = _usuario.text.trim();
    final contrasena = _contrasena.text.trim();

    // Validacion local antes de llamar API.
    if (usuario.isEmpty || contrasena.isEmpty) {
      setState(() => _error = 'Completa usuario y contrasena');
      return;
    }

    setState(() {
      _cargando = true;
      _error = null;
    });

    bool biometriaValidada = false;
    if (!_esLogin) {
      if (!_biometriaDisponible) {
        setState(() {
          _cargando = false;
          _error = 'Para registrarte debes tener biometria disponible';
        });
        return;
      }

      setState(() => _autenticandoBiometria = true);
      final validacion = await _biometria.autenticar(
        motivo: 'Confirma tu huella para completar el registro',
      );

      if (!mounted) return;

      setState(() => _autenticandoBiometria = false);

      if (!validacion.exito) {
        setState(() {
          _cargando = false;
          _error = validacion.mensaje;
        });
        return;
      }

      biometriaValidada = true;
    }

    // Segun el modo, llamamos endpoint de login o registro.
    final resultado = _esLogin
        ? await _api.iniciarSesion(usuario, contrasena)
        : await _api.registrar(
            usuario,
            contrasena,
            biometriaHabilitada: biometriaValidada,
          );

    if (!mounted) return;

    setState(() => _cargando = false);

    // Si backend responde error, lo mostramos debajo de los campos.
    if (!resultado.exito) {
      setState(() => _error = resultado.mensaje);
      return;
    }

    // Flujo exitoso: login navega a bienvenida, registro cambia a login.
    if (_esLogin) {
      // Guardamos credenciales tras login correcto para poder entrar con huella.
      await _credencialesBiometricas.guardar(
        usuario: usuario,
        contrasena: contrasena,
      );
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) =>
              PaginaBienvenida(usuario: resultado.usuario ?? usuario),
        ),
      );
    } else {
      await _credencialesBiometricas.guardar(
        usuario: usuario,
        contrasena: contrasena,
      );
      if (!mounted) return;
      setState(() => _esLogin = true);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(resultado.mensaje)));
    }
  }

  // Permite acceso usando huella/biometria cuando esta disponible.
  Future<void> _autenticarConBiometria() async {
    FocusScope.of(context).unfocus();
    final usuario = _usuario.text.trim();

    if (usuario.isEmpty) {
      setState(() {
        _error = 'Escribe tu usuario para ingresar con huella';
      });
      return;
    }

    final tieneCredenciales = await _credencialesBiometricas.tieneCredenciales(
      usuario,
    );

    if (!mounted) return;

    if (!tieneCredenciales) {
      setState(() {
        _error =
            'Este usuario aun no tiene huella activa. Inicia con contrasena primero';
      });
      return;
    }

    setState(() {
      _autenticandoBiometria = true;
      _error = null;
    });

    final resultado = await _biometria.autenticar(
      motivo: 'Confirma tu identidad para continuar',
    );

    if (!mounted) return;

    setState(() => _autenticandoBiometria = false);

    if (!resultado.exito) {
      setState(() => _error = resultado.mensaje);
      return;
    }

    final contrasena = await _credencialesBiometricas.leerContrasena(usuario);
    if (!mounted) return;

    if (contrasena == null) {
      setState(() {
        _error = 'No hay credenciales guardadas para este usuario';
      });
      return;
    }

    setState(() => _cargando = true);
    final login = await _api.iniciarSesion(usuario, contrasena);

    if (!mounted) return;
    setState(() => _cargando = false);

    if (!login.exito) {
      await _credencialesBiometricas.limpiar(usuario);
      if (!mounted) return;
      setState(() {
        _error = 'Credenciales desactualizadas. Inicia sesion nuevamente';
      });
      return;
    }

    _usuario.text = usuario;
    _contrasena.text = contrasena;

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => PaginaBienvenida(usuario: login.usuario ?? usuario),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Construccion de UI con formulario, acciones y estado de red.
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
            if (_esLogin && _biometriaDisponible) ...[
              const SizedBox(height: 8),
              Text(
                'Para ingresar con huella, escribe tu usuario.',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
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
              cargando: _cargando || _autenticandoBiometria,
              alPresionar: _enviar,
            ),
            if (_esLogin && _biometriaDisponible) ...[
              const SizedBox(height: 8),
              OutlinedButton.icon(
                onPressed: _cargando || _autenticandoBiometria
                    ? null
                    : _autenticarConBiometria,
                icon: const Icon(Icons.fingerprint),
                label: Text('Ingresar con $_etiquetaBiometria'),
              ),
            ],
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
