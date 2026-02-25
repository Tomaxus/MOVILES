// Importa los widgets de Material Design (botones, colores, Scaffold, etc.)
import 'package:flutter/material.dart';

// Widget principal de la calculadora
class CalculatorUI extends StatefulWidget {
  // Constructor del widget
  const CalculatorUI({super.key});

  // Crea el estado del widget
  @override
  State<CalculatorUI> createState() => _CalculatorUIState();
}

// Clase donde va la lógica de la calculadora
class _CalculatorUIState extends State<CalculatorUI> {
  // Texto que se muestra en la pantalla
  String pantalla = '0';

  // Guarda el primer número de la operación
  double? numeroAnterior;

  // Guarda el operador matemático
  String operacion = '';

  // Indica si se empieza a escribir un número nuevo
  bool nuevaOperacion = true;

  // Construye la interfaz visual
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],

      body: Center(
        child: Container(
          width: 300,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Pantalla
              Container(
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.all(16),
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(pantalla, style: const TextStyle(fontSize: 32)),
              ),

              // Botones
              SizedBox(
                height: 360,
                child: Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: Column(
                        children: [
                          buildRow(['AC', '+/-', '%']),
                          buildRow(['7', '8', '9']),
                          buildRow(['4', '5', '6']),
                          buildRow(['1', '2', '3']),
                          buildRow(['.', '0', '=']),
                        ],
                      ),
                    ),

                    Expanded(
                      flex: 1,
                      child: Column(
                        children: [
                          buildButtonOp('÷'),
                          buildButtonOp('x'),
                          buildButtonOp('-'),
                          Expanded(
                            flex: 2,
                            child: buildOrangeButton('+', () => presionar('+')),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // FILAS DE BOTONES
  Widget buildRow(List<String> texts) {
    return Expanded(
      child: Row(
        children: texts.map((t) {
          return Expanded(child: buildButton(t, () => presionar(t)));
        }).toList(),
      ),
    );
  }

  // Botón gris normal
  Widget buildButton(String text, VoidCallback onPressed) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        margin: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: Colors.grey[400],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(child: Text(text, style: const TextStyle(fontSize: 20))),
      ),
    );
  }

  // Botón operador gris
  Widget buildButtonOp(String text) {
    return Expanded(child: buildButton(text, () => presionar(text)));
  }

  // Botón naranja
  Widget buildOrangeButton(String text, VoidCallback onPressed) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        margin: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: Colors.orange,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Text(
            text,
            style: const TextStyle(fontSize: 22, color: Colors.white),
          ),
        ),
      ),
    );
  }

  String formatNumber(double num) {
    if (num % 1 == 0) {
      return num.toInt().toString();
    } else {
      return num.toString();
    }
  }

  // logica para manejar las pulsaciones de los botones

  void presionar(String valor) {
    setState(() {
      if (valor == 'AC') {
        pantalla = '0';
        numeroAnterior = null;
        operacion = '';
        nuevaOperacion = true;
        return;
      }

      // CAMBIAR SIGNO
      if (valor == '+/-') {
        double num = double.parse(pantalla);
        pantalla = formatNumber(num * -1);
        return;
      }

      // PORCENTAJE
      if (valor == '%') {
        double num = double.parse(pantalla);
        pantalla = formatNumber(num / 100);
        return;
      }

      // OPERADORES
      if (['+', '-', 'x', '÷'].contains(valor)) {
        // Si hay una operación pendiente, calcula primero
        if (numeroAnterior != null && !nuevaOperacion) {
          _calcular(double.parse(pantalla));
        }

        numeroAnterior = double.parse(pantalla);
        operacion = valor;
        nuevaOperacion = true;
        return;
      }

      // IGUAL
      if (valor == '=') {
        if (numeroAnterior != null && operacion.isNotEmpty) {
          _calcular(double.parse(pantalla));
          numeroAnterior = null;
          operacion = '';
          nuevaOperacion = true;
        }
        return;
      }

      // NUMEROS Y DECIMAL
      if (nuevaOperacion) {
        pantalla = valor == '.' ? '0.' : valor;
        nuevaOperacion = false;
      } else {
        if (valor == '.' && pantalla.contains('.')) return;
        pantalla = pantalla == '0' ? valor : pantalla + valor;
      }
    });
  }

  // FUNCIÓN PARA CALCULAR
  void _calcular(double num2) {
    double resultado = 0;

    switch (operacion) {
      case '+':
        resultado = numeroAnterior! + num2;
        break;
      case '-':
        resultado = numeroAnterior! - num2;
        break;
      case 'x':
        resultado = numeroAnterior! * num2;
        break;
      case '÷':
        resultado = num2 == 0 ? 0 : numeroAnterior! / num2;
        break;
    }

    pantalla = formatNumber(resultado);
  }
}
