import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

class CalculatorPage extends StatefulWidget {
  const CalculatorPage({super.key});

  @override
  State<CalculatorPage> createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {
  String _expression = '';
  String _result = '';

  void _onPressed(String value) {
    setState(() {
      if (value == 'C') {
        _expression = '';
        _result = '';
      } else if (value == '⌫') {
        if (_expression.isNotEmpty) {
          _expression = _expression.substring(0, _expression.length - 1);
        }
      } else if (value == '=') {
        try {
          final exp = _expression.replaceAll('x', '*').replaceAll('÷', '/');
          _result = _calculateResult(exp);
        } catch (_) {
          _result = 'Error';
        }
      } else {
        _expression += value;
      }
    });
  }

  String _calculateResult(String expr) {
    try {
      Parser p = Parser();
      Expression exp = p.parse(expr);
      ContextModel cm = ContextModel();
      double eval = exp.evaluate(EvaluationType.REAL, cm);
      return eval.toString();
    } catch (_) {
      return expr;
    }
  }

  // Widget _buildButton(String text){
  //   return ElevatedButton(
  //     onPressed: () => _onPressed(text),
  //     style: ElevatedButton.styleFrom(
  //       backgroundColor: Colors.indigo.shade100,
  //       foregroundColor: Colors.black,
  //       padding: const EdgeInsets.all(20)
  //     ),
  //     child: Text(
  //       text,
  //       style: const TextStyle(fontSize: 20),
  //     ),
  //   );
  // }

  // Widget _buildButton(String label, {Color? bgColor, Color? textColor}){
  //   return GestureDetector(
  //     onTap:() => _onPressed(label),
  //     child: Container(
  //       margin: const EdgeInsets.all(6),
  //       decoration: BoxDecoration(
  //         color: bgColor ?? Colors.grey.shade900,
  //         borderRadius: BorderRadius.circular(16),
  //       ),
  //       alignment: Alignment.center,
  //       child: Text(
  //         label,
  //         style: TextStyle(
  //           fontSize: 26,
  //           color: textColor ?? Colors.white,
  //           fontWeight: FontWeight.w500,
  //         )
  //       )
  //     )
  //   );
  // }

  Widget _buildButton(String label, {Color? bgColor, Color? textColor}) {
    return GestureDetector(
      onTap: () => _onPressed(label),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeInOut,
        margin: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: bgColor ?? Colors.grey.shade900,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withOpacity(0.1), width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              offset: const Offset(2, 2),
              blurRadius: 4,
            ),
            BoxShadow(
              color: Colors.white.withOpacity(0.05),
              offset: const Offset(-2, -2),
              blurRadius: 4,
            ),
          ],
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            fontSize: 26,
            color: textColor ?? Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<String> buttons = [
      'C',
      '÷',
      '×',
      '⌫',
      '7',
      '8',
      '9',
      '-',
      '4',
      '5',
      '6',
      '+',
      '1',
      '2',
      '3',
      '=',
      '0',
      '.',
      '',
      '',
    ];

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Calculator'),
        // backgroundColor: Colors.black,
        // elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            flex: 2,
            child: Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.grey.shade900,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white.withOpacity(0.1)),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              alignment: Alignment.bottomRight,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    _expression,
                    style: const TextStyle(fontSize: 28, color: Colors.grey),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    _result,
                    style: const TextStyle(fontSize: 42, color: Colors.white),
                  ),
                ],
              ),
            ),
          ),

          // Expanded(
          //   flex: 2,
          //   child: Container(
          //     padding: const EdgeInsets.all(24),
          //     alignment: Alignment.bottomRight,
          //     child: Column(
          //       mainAxisAlignment: MainAxisAlignment.end,
          //       crossAxisAlignment: CrossAxisAlignment.end,
          //       children: [
          //         Text(
          //           _expression,
          //           style: const TextStyle(
          //             fontSize: 28,
          //             color: Colors.grey
          //           )
          //         ),
          //         const SizedBox(height: 12),
          //         Text(
          //           _result,
          //           style: const TextStyle(
          //             fontSize: 42,
          //             color: Colors.white,
          //           )
          //         )
          //       ],
          //     ),
          //   ),
          // ),
          Expanded(
            flex: 5,
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: buttons.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 14,
                mainAxisSpacing: 14,
              ),
              itemBuilder: (context, index) {
                final btn = buttons[index];
                if (btn.isEmpty) return const SizedBox();
                final isOperator = '÷×+-=C⌫'.contains(btn);
                return _buildButton(
                  btn,
                  bgColor: isOperator ? Colors.indigo : Colors.grey.shade800,
                  textColor: isOperator ? Colors.white : Colors.white70,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
