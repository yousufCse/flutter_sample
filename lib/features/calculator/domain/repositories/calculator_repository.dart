import 'package:flutter_sample/features/calculator/data/repositories/calculator_repository_impl.dart';

abstract class CalculatorRepository {
  static CalculatorRepository? _instance;

  static CalculatorRepository instance() {
    if (_instance == null) {
      _instance = CalculatorRepositoryImpl();
      return _instance!;
    }
    return _instance!;
  }

  double add(double a, double b);
  double subtract(double a, double b);
  double multiply(double a, double b);
  double divide(double a, double b);
}
