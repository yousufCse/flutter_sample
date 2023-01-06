import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sample/cubit/counter_cubit.dart';
import 'package:flutter_sample/second_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late CounterCubit counterCubit;

  @override
  void initState() {
    counterCubit = BlocProvider.of<CounterCubit>(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CounterCubit, CounterState>(
      listener: (context, state) {
        debugPrint('BlocListener MainScreen: ${state.count}');
      },
      child: SafeArea(
        child: Scaffold(
            appBar: AppBar(title: Text('Main Screen')),
            body: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
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
                  onPressed: counterCubit.increment,
                  child: const Text('Increment'),
                ),
                ElevatedButton(
                  onPressed: counterCubit.decrement,
                  child: const Text('Decrement'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          fullscreenDialog: true,
                          builder: (context) {
                            return SecondScreen(cubit: counterCubit);
                          },
                        ));
                  },
                  child: const Text('Open Bottom Sheet'),
                ),
              ],
            )),
      ),
    );
  }
}
