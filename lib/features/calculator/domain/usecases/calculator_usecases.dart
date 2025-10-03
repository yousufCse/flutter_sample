import '../repositories/calculator_repository.dart';

class AddUseCase {
  final CalculatorRepository repository;
  AddUseCase(this.repository);

  double call(double a, double b) => repository.add(a, b);
}

class SubtractUseCase {
  final CalculatorRepository repository;
  SubtractUseCase(this.repository);

  double call(double a, double b) => repository.subtract(a, b);
}

class MultiplyUseCase {
  final CalculatorRepository repository;
  MultiplyUseCase(this.repository);

  double call(double a, double b) => repository.multiply(a, b);
}

class DivideUseCase {
  final CalculatorRepository repository;
  DivideUseCase(this.repository);

  double call(double a, double b) => repository.divide(a, b);
}
