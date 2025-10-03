import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sample/features/calculator/domain/repositories/calculator_repository.dart';

import '../../domain/usecases/calculator_usecases.dart';
import '../bloc/calculator_bloc.dart';

class CalculatorScreen extends StatelessWidget {
  const CalculatorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CalculatorBloc(
        addUseCase: AddUseCase(CalculatorRepository.instance()),
        subtractUseCase: SubtractUseCase(CalculatorRepository.instance()),
        multiplyUseCase: MultiplyUseCase(CalculatorRepository.instance()),
        divideUseCase: DivideUseCase(CalculatorRepository.instance()),
      ),
      child: const CalculatorView(),
    );
  }
}

class CalculatorView extends StatelessWidget {
  const CalculatorView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Expanded(
              child: Container(
                alignment: Alignment.bottomRight,
                padding: const EdgeInsets.all(24),
                child: BlocBuilder<CalculatorBloc, CalculatorState>(
                  builder: (context, state) {
                    return Text(
                      state.display,
                      style: const TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    );
                  },
                ),
              ),
            ),
            _buildButtonRow(context, ['7', '8', '9', '÷']),
            _buildButtonRow(context, ['4', '5', '6', '×']),
            _buildButtonRow(context, ['1', '2', '3', '-']),
            _buildButtonRow(context, ['C', '0', '=', '+']),
          ],
        ),
      ),
    );
  }

  Widget _buildButtonRow(BuildContext context, List<String> labels) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: labels.map((label) => _buildButton(context, label)).toList(),
    );
  }

  Widget _buildButton(BuildContext context, String label) {
    final isOperator = ['+', '-', '×', '÷', '='].contains(label);
    final isClear = label == 'C';
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        width: 72,
        height: 72,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: isOperator
                ? Colors.blueAccent
                : isClear
                    ? Colors.redAccent
                    : Colors.white,
            foregroundColor:
                isOperator || isClear ? Colors.white : Colors.black87,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
            elevation: 2,
          ),
          onPressed: () {
            final bloc = context.read<CalculatorBloc>();
            if (isOperator) {
              if (label == '=') {
                bloc.add(EqualsPressed());
              } else {
                bloc.add(OperatorPressed(label));
              }
            } else if (isClear) {
              bloc.add(ClearPressed());
            } else {
              bloc.add(NumberPressed(label));
            }
          },
          child: Text(
            label,
            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }
}
