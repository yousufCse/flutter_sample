import 'package:flutter_bloc/flutter_bloc.dart';

part 'counter_state.dart';

class CounterCubit extends Cubit<CounterState> {
  CounterCubit() : super(const CounterState(count: 0));

  void increment() {
    emit(state.copyWith(state.count + 1));
  }

  void decrement() {
    emit(state.copyWith(state.count - 1));
  }
}
