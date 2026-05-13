import 'package:flutter/material.dart';
import '../models/personaje.dart';
import '../widgets/tarjeta_personaje.dart';

class WidgetGridPersonajes extends StatelessWidget {
  final List<Personaje> personajes;
  final Function(Personaje) alPresionar;

  const WidgetGridPersonajes({
    super.key,
    required this.personajes,
    required this.alPresionar,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.75,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: personajes.length,
      itemBuilder: (context, index) {
        return TarjetaPersonaje(
          personaje: personajes[index],
          alPresionar: () => alPresionar(personajes[index]),
        );
      },
    );
  }
}
