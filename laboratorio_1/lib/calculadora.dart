// Importa los widgets de Material Design (botones, colores, Scaffold, etc.)
import 'package:flutter/material.dart';

// Widget principal de la calculadora (puede cambiar su estado)
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

  // Guarda el operador matemático (+, -, x, ÷)
  String operacion = '';

  // Indica si se empieza a escribir un número nuevo
  bool nuevaOperacion = true;

  // Construye la interfaz visual
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Color del fondo
      backgroundColor: Colors.grey[200],

      // Centra la calculadora en pantalla
      body: Center(
        child: Container(
          width: 300, // Ancho de la calculadora
          padding: const EdgeInsets.all(16), // Espaciado interno
          decoration: BoxDecoration(
            color: Colors.white, // Color del cuerpo
            borderRadius: BorderRadius.circular(20), // Bordes redondeados
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Pantalla de la calculadora
              Container(
                alignment: Alignment.centerRight, // Texto a la derecha
                padding: const EdgeInsets.all(16),
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.grey[300], // Fondo de pantalla
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  pantalla,
                  style: const TextStyle(fontSize: 32),
                ), // Muestra el número
              ),

              // Área de botones
              SizedBox(
                height: 360,
                child: Row(
                  children: [
                    // Columna izquierda (números y funciones)
                    Expanded(
                      flex: 3,
                      child: Column(
                        children: [
                          // Fila AC, +/-, %
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

                          // Fila 7 8 9
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

                          // Fila 4 5 6
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

                          // Fila 1 2 3
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

                          // Fila . 0 =
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

                    // Columna derecha (operadores)
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

  // Botón gris normal
  Widget buildButton(String text, VoidCallback onPressed) {
    return GestureDetector(
      onTap: onPressed, // Detecta el toque
      child: Container(
        margin: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: Colors.grey[400], // Color gris
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Text(text, style: const TextStyle(fontSize: 20)),
        ), // Texto del botón
      ),
    );
  }

  // Botón naranja (para suma)
  Widget buildOrangeButton(String text, VoidCallback onPressed) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        margin: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: Colors.orange, // Color naranja
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

  // Función que maneja lo que pasa cuando presionas un botón
  void presionar(String valor) {
    setState(() {
      // Actualiza la pantalla

      // Botón AC: reinicia todo
      if (valor == 'AC') {
        pantalla = '0';
        numeroAnterior = null;
        operacion = '';
        nuevaOperacion = true;
      }
      // Cambiar signo
      else if (valor == '+/-') {
        double num = double.parse(pantalla);
        pantalla = (num * -1).toString();
      }
      // Porcentaje
      else if (valor == '%') {
        double num = double.parse(pantalla);
        pantalla = (num / 100).toString();
      }
      // Guarda operador y primer número
      else if (['+', '-', 'x', '÷'].contains(valor)) {
        numeroAnterior = double.parse(pantalla);
        operacion = valor;
        nuevaOperacion = true;
      }
      // Calcula el resultado
      else if (valor == '=') {
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

          pantalla = resultado.toString(); // Muestra resultado
          numeroAnterior = null;
          operacion = '';
          nuevaOperacion = true;
        }
      }
      // Escribir números y punto
      else {
        if (nuevaOperacion) {
          pantalla = valor; // Reemplaza pantalla
          nuevaOperacion = false;
        } else {
          if (valor == '.' && pantalla.contains('.'))
            return; // Evita doble punto
          pantalla = pantalla == '0'
              ? valor
              : pantalla + valor; // Agrega número
        }
      }
    });
  }
}
