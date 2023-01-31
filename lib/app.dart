import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sample/core/dependency.dart';
import 'package:flutter_sample/features/location_search/presentation/cubit/agent_info_api_cubit.dart';
import 'package:flutter_sample/features/location_search/presentation/cubit/place_details_api_cubit.dart';
import 'package:flutter_sample/features/location_search/presentation/cubit/prediction_api_cubit.dart';
import 'package:flutter_sample/features/location_search/presentation/screen/location_search_screen.dart';

class App extends StatelessWidget {
  const App({super.key});

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
          BlocProvider(
            create: (context) => sl<AgentInfoApiCubit>(),
          ),
        ],
        child: const LocationSearchScreen(),
      ),
    );
  }
}
