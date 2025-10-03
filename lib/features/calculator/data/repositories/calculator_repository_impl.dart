import '../../domain/repositories/calculator_repository.dart';

class CalculatorRepositoryImpl implements CalculatorRepository {
  @override
  double add(double a, double b) => a + b;

  @override
  double subtract(double a, double b) => a - b;

  @override
  double multiply(double a, double b) => a * b;

  @override
  double divide(double a, double b) {
    if (b == 0) throw Exception('Division by zero');
    return a / b;
  }
}
