import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sample/cubit/counter_cubit.dart';

class SecondScreen extends StatefulWidget {
  final CounterCubit cubit;
  const SecondScreen({required this.cubit, super.key});

  @override
  State<SecondScreen> createState() => _SecondScreenState();
}

class _SecondScreenState extends State<SecondScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: widget.cubit,
      child: _scaffold(context),
    );
  }

  Widget _scaffold(BuildContext context) {
    return BlocListener<CounterCubit, CounterState>(
      listener: (context, state) {
        debugPrint('BlocListener SecondScreen: ${state.count}');
      },
      child: Scaffold(
        appBar: AppBar(title: Text('Second Screen')),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            BlocBuilder<CounterCubit, CounterState>(
              builder: (context, state) {
                return Text(
                  state.count.toString(),
                  style: const TextStyle(color: Colors.green, fontSize: 20),
                );
              },
            ),
            ElevatedButton(
              onPressed: widget.cubit.increment,
              child: const Text('Increment'),
            ),
            ElevatedButton(
              onPressed: widget.cubit.decrement,
              child: const Text('Decrement'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Close Bottom Sheet'),
            ),
          ],
        ),
      ),
    );
  }
}
