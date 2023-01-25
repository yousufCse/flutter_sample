import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sample/core/dependency.dart';
import 'package:flutter_sample/features/agent_place/presentation/cubit/place_details_api_cubit.dart';
import 'package:flutter_sample/features/agent_place/presentation/cubit/prediction_api_cubit.dart';
import 'package:flutter_sample/features/agent_place/presentation/screen/agent_place_screen.dart';

class App extends StatelessWidget {
  App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => sl<PlaceDetailsApiCubit>(),
          ),
          BlocProvider(
            create: (context) => sl<PredictionApiCubit>(),
          ),
        ],
        child: const AgentPlaceScreen(),
      ),
    );
  }
}
