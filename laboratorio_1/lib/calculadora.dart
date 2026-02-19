import 'package:flutter/material.dart';

// Widget principal de la calculadora
class CalculatorUI extends StatefulWidget {
  const CalculatorUI({super.key});

  @override
  State<CalculatorUI> createState() => _CalculatorUIState();
}

class _CalculatorUIState extends State<CalculatorUI> {
  // Variables para almacenar el estado de la calculadora
  String pantalla = '0'; // Texto mostrado en la pantalla
  double? numeroAnterior; // Primer número de la operación
  String operacion = ''; // Operador (+, -, x, ÷)
  bool nuevaOperacion = true; // Indica si debe empezar nueva entrada

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
              // Pantalla de la calculadora - muestra el número actual
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

              // Grilla de botones: números y operaciones
              SizedBox(
                height: 360,
                child: Row(
                  children: [
                    // Left 3 columns as 5 rows
                    Expanded(
                      flex: 3,
                      child: Column(
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                Expanded(
                                  child: buildButton(
                                    'AC',
                                    () => presionar('AC'),
                                  ),
                                ),
                                Expanded(
                                  child: buildButton(
                                    '+/-',
                                    () => presionar('+/-'),
                                  ),
                                ),
                                Expanded(
                                  child: buildButton('%', () => presionar('%')),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Row(
                              children: [
                                Expanded(
                                  child: buildButton('7', () => presionar('7')),
                                ),
                                Expanded(
                                  child: buildButton('8', () => presionar('8')),
                                ),
                                Expanded(
                                  child: buildButton('9', () => presionar('9')),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Row(
                              children: [
                                Expanded(
                                  child: buildButton('4', () => presionar('4')),
                                ),
                                Expanded(
                                  child: buildButton('5', () => presionar('5')),
                                ),
                                Expanded(
                                  child: buildButton('6', () => presionar('6')),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Row(
                              children: [
                                Expanded(
                                  child: buildButton('1', () => presionar('1')),
                                ),
                                Expanded(
                                  child: buildButton('2', () => presionar('2')),
                                ),
                                Expanded(
                                  child: buildButton('3', () => presionar('3')),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Row(
                              children: [
                                Expanded(
                                  child: buildButton('.', () => presionar('.')),
                                ),
                                Expanded(
                                  child: buildButton('0', () => presionar('0')),
                                ),
                                Expanded(
                                  child: buildButton('=', () => presionar('=')),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    Expanded(
                      flex: 1,
                      child: Column(
                        children: [
                          Expanded(
                            child: buildButton('÷', () => presionar('÷')),
                          ),
                          Expanded(
                            child: buildButton('x', () => presionar('x')),
                          ),
                          Expanded(
                            child: buildButton('-', () => presionar('-')),
                          ),
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

  // Crea un botón gris estándar
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

  // Crea un botón naranja (para la suma)
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

  // Maneja los eventos de los botones
  void presionar(String valor) {
    setState(() {
      if (valor == 'AC') {
        // Limpia todo y vuelve al estado inicial
        pantalla = '0';
        numeroAnterior = null;
        operacion = '';
        nuevaOperacion = true;
      } else if (valor == '+/-') {
        // Cambia el signo del número actual
        double num = double.parse(pantalla);
        pantalla = (num * -1).toString();
      } else if (valor == '%') {
        // Convierte el número a porcentaje
        double num = double.parse(pantalla);
        pantalla = (num / 100).toString();
      } else if (['+', '-', 'x', '÷'].contains(valor)) {
        // Guarda el número y la operación para cálculo posterior
        numeroAnterior = double.parse(pantalla);
        operacion = valor;
        nuevaOperacion = true;
      } else if (valor == '=') {
        // Calcula el resultado usando los dos números y la operación
        if (numeroAnterior != null && operacion.isNotEmpty) {
          double num2 = double.parse(pantalla);
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
              resultado = num2 != 0 ? numeroAnterior! / num2 : 0;
              break;
          }

          pantalla = resultado.toString();
          numeroAnterior = null;
          operacion = '';
          nuevaOperacion = true;
        }
      } else {
        // Ingresa números y el punto decimal
        if (nuevaOperacion) {
          pantalla = valor;
          nuevaOperacion = false;
        } else {
          if (valor == '.' && pantalla.contains('.')) {
            return; // Evita múltiples puntos
          }
          pantalla = pantalla == '0' ? valor : pantalla + valor;
        }
      }
    });
  }
}
