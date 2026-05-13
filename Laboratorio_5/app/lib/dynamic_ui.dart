import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'screens/pantalla_personajes.dart';

class DynamicUI extends StatefulWidget {
  final String jsonAssetPath;
  const DynamicUI({Key? key, required this.jsonAssetPath}) : super(key: key);

  @override
  State<DynamicUI> createState() => _DynamicUIState();
}

class _DynamicUIState extends State<DynamicUI> {
  List<dynamic>? widgetsJson;

  @override
  void initState() {
    super.initState();
    _loadJson();
  }

  Future<void> _loadJson() async {
    final String jsonStr = await rootBundle.loadString(widget.jsonAssetPath);
    final Map<String, dynamic> jsonData = json.decode(jsonStr);
    setState(() {
      widgetsJson = jsonData['widgets'] as List<dynamic>?;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFe0c3fc), Color(0xFF8ec5fc)],
        ),
      ),
      child: widgetsJson == null
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(24),
              children: widgetsJson!
                  .map(
                    (w) =>
                        buildWidgetFromJson(w as Map<String, dynamic>, context),
                  )
                  .toList(),
            ),
    );
  }

  Widget buildWidgetFromJson(Map<String, dynamic> json, BuildContext context) {
    switch (json['type']) {
      case 'text':
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 12),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.85),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.07),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Text(
            json['value'] ?? '',
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w600,
              color: Color(0xFF2d2d2d),
            ),
          ),
        );
      case 'button':
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 12),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: const Color(0xFF7f53ac),
              elevation: 2,
              padding: const EdgeInsets.symmetric(vertical: 18),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
                side: const BorderSide(color: Color(0xFF7f53ac), width: 2),
              ),
              textStyle: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            onPressed: () {
              if (json['action'] == 'show_message') {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('¡Botón presionado!')),
                );
              }
            },
            child: Text(json['label'] ?? 'Botón'),
          ),
        );
      case 'list':
        final items = json['items'] as List<dynamic>? ?? [];
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.85),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.07),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ...items
                  .map(
                    (item) => buildWidgetFromJson(
                      item as Map<String, dynamic>,
                      context,
                    ),
                  )
                  .toList(),
            ],
          ),
        );
      case 'personajes':
        // Renderiza la lista de personajes desde la API existente
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 16),
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.7),
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: SizedBox(height: 500, child: ListaPersonajes()),
        );
      default:
        return const SizedBox.shrink();
    }
  }
}
