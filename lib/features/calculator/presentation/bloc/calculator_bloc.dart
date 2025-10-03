import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/calculator_usecases.dart';

abstract class CalculatorEvent {}

class NumberPressed extends CalculatorEvent {
  final String number;
  NumberPressed(this.number);
}

class OperatorPressed extends CalculatorEvent {
  final String operatorSymbol;
  OperatorPressed(this.operatorSymbol);
}

class EqualsPressed extends CalculatorEvent {}

class ClearPressed extends CalculatorEvent {}

class CalculatorState {
  final String display;
  final String? operatorSymbol;
  final double? firstOperand;
  final double? secondOperand;
  final bool shouldClear;

  CalculatorState({
    required this.display,
    this.operatorSymbol,
    this.firstOperand,
    this.secondOperand,
    this.shouldClear = false,
  });

  CalculatorState copyWith({
    String? display,
    String? operatorSymbol,
    double? firstOperand,
    double? secondOperand,
    bool? shouldClear,
  }) {
    return CalculatorState(
      display: display ?? this.display,
      operatorSymbol: operatorSymbol ?? this.operatorSymbol,
      firstOperand: firstOperand ?? this.firstOperand,
      secondOperand: secondOperand ?? this.secondOperand,
      shouldClear: shouldClear ?? this.shouldClear,
    );
  }
}

class CalculatorBloc extends Bloc<CalculatorEvent, CalculatorState> {
  final AddUseCase addUseCase;
  final SubtractUseCase subtractUseCase;
  final MultiplyUseCase multiplyUseCase;
  final DivideUseCase divideUseCase;

  CalculatorBloc({
    required this.addUseCase,
    required this.subtractUseCase,
    required this.multiplyUseCase,
    required this.divideUseCase,
  }) : super(CalculatorState(display: '0')) {
    on<NumberPressed>(_onNumberPressed);
    on<OperatorPressed>(_onOperatorPressed);
    on<EqualsPressed>(_onEqualsPressed);
    on<ClearPressed>(_onClearPressed);
  }

  void _onNumberPressed(NumberPressed event, Emitter<CalculatorState> emit) {
    if (state.shouldClear) {
      emit(state.copyWith(display: event.number, shouldClear: false));
    } else {
      final newDisplay =
          state.display == '0' ? event.number : state.display + event.number;
      emit(state.copyWith(display: newDisplay));
    }
  }

  void _onOperatorPressed(
      OperatorPressed event, Emitter<CalculatorState> emit) {
    final firstOperand = double.tryParse(state.display) ?? 0;
    emit(state.copyWith(
      firstOperand: firstOperand,
      operatorSymbol: event.operatorSymbol,
      shouldClear: true,
    ));
  }

  void _onEqualsPressed(EqualsPressed event, Emitter<CalculatorState> emit) {
    final secondOperand = double.tryParse(state.display) ?? 0;
    final firstOperand = state.firstOperand ?? 0;
    double result = 0;
    try {
      switch (state.operatorSymbol) {
        case '+':
          result = addUseCase(firstOperand, secondOperand);
          break;
        case '-':
          result = subtractUseCase(firstOperand, secondOperand);
          break;
        case '×':
          result = multiplyUseCase(firstOperand, secondOperand);
          break;
        case '÷':
          result = divideUseCase(firstOperand, secondOperand);
          break;
        default:
          result = secondOperand;
      }
      emit(state.copyWith(
        display: result.toString(),
        firstOperand: null,
        operatorSymbol: null,
        shouldClear: true,
      ));
    } catch (e) {
      emit(state.copyWith(display: 'Error', shouldClear: true));
    }
  }

  void _onClearPressed(ClearPressed event, Emitter<CalculatorState> emit) {
    emit(CalculatorState(display: '0'));
  }
}
