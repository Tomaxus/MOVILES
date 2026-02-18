import 'package:flutter/material.dart';

class CalculatorUI extends StatelessWidget {
  const CalculatorUI({super.key});

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
                child: const Text('0', style: TextStyle(fontSize: 32)),
              ),

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
                                Expanded(child: buildButton('AC')),
                                Expanded(child: buildButton('+/-')),
                                Expanded(child: buildButton('%')),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Row(
                              children: [
                                Expanded(child: buildButton('7')),
                                Expanded(child: buildButton('8')),
                                Expanded(child: buildButton('9')),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Row(
                              children: [
                                Expanded(child: buildButton('4')),
                                Expanded(child: buildButton('5')),
                                Expanded(child: buildButton('6')),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Row(
                              children: [
                                Expanded(child: buildButton('1')),
                                Expanded(child: buildButton('2')),
                                Expanded(child: buildButton('3')),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Row(
                              children: [
                                Expanded(child: buildButton('.')),
                                Expanded(child: buildButton('0')),
                                Expanded(child: buildButton('=')),
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
                          Expanded(child: buildButton('÷')),
                          Expanded(child: buildButton('x')),
                          Expanded(child: buildButton('-')),
                          Expanded(flex: 2, child: buildOrangeButton('+')),
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

  Widget buildButton(String text) {
    return Container(
      margin: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: Colors.grey[400],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(child: Text(text, style: const TextStyle(fontSize: 20))),
    );
  }

  Widget buildOrangeButton(String text) {
    return Container(
      margin: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: Colors.orange,
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Center(
        child: Text('+', style: TextStyle(fontSize: 22, color: Colors.white)),
      ),
    );
  }
}
