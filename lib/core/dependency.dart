import 'package:flutter_sample/core/location_service/location_service.dart';
import 'package:flutter_sample/features/agent_location/data/datasource/agent_location_remote.dart';
import 'package:flutter_sample/features/agent_location/data/repository/agent_location_repository_impl.dart';
import 'package:flutter_sample/features/agent_location/domain/repository/agent_location_repository.dart';
import 'package:flutter_sample/features/agent_location/domain/usecase/get_agent_list_usecase.dart';
import 'package:flutter_sample/features/agent_location/presentation/cubit/agent_location_cubit.dart';
import 'package:flutter_sample/features/agent_location/presentation/cubit/marker_item/marker_item_tap_cubit.dart';
import 'package:flutter_sample/features/agent_location/presentation/cubit/search/location_search_cubit.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart';

final sl = GetIt.instance;

setup() {
  // Cubit

  sl.registerLazySingleton(() => LocationSearchCubit());
  sl.registerLazySingleton(() => AgentLocationCubit(
      locationService: sl(),
      markerItemTapCubit: sl(),
      getAgentListUsecase: sl()));
  sl.registerLazySingleton(() => MarkerItemTapCubit());

  // Usecase
  sl.registerLazySingleton(() => GetAgentListUsecase(repository: sl()));

  // Repository
  sl.registerLazySingleton<AgentLocationRepository>(
      () => AgentLocationRepositoryImpl(remote: sl()));

  // Data Source
  sl.registerLazySingleton<AgentLocationRemote>(
      () => AgentLocationRemoteImpl(client: sl()));

  sl.registerLazySingleton(() => Client());

  // Service
  sl.registerLazySingleton<LocationService>(() => LocationServiceImpl());
}
