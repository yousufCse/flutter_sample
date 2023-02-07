import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sample/core/dependency.dart';
import 'package:flutter_sample/features/agent_location/presentation/cubit/agent_location_cubit.dart';
import 'package:flutter_sample/features/agent_location/presentation/cubit/api/agent_location_api_cubit.dart';
import 'package:flutter_sample/features/agent_location/presentation/cubit/location_search_cubit.dart';
import 'package:flutter_sample/features/agent_location/presentation/cubit/marker_item/marker_item_tap_cubit.dart';
import 'package:flutter_sample/features/agent_location/presentation/screen/agent_location_screen.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => sl<AgentLocationApiCubit>(),
          ),
          BlocProvider(
            create: (context) => sl<LocationSearchCubit>(),
          ),
          BlocProvider(
            create: (context) => sl<AgentLocationCubit>(),
          ),
          BlocProvider(
            create: (context) => sl<MarkerItemTapCubit>(),
          ),
        ],
        child: const AgentLocationScreen(),
      ),
    );
  }
}
