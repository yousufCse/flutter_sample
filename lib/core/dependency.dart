import 'package:flutter_sample/features/agent_place/data/datasource/agent_place_remote.dart';
import 'package:flutter_sample/features/agent_place/data/repository/agent_place_repository_impl.dart';
import 'package:flutter_sample/features/agent_place/domain/repository/agent_place_repository.dart';
import 'package:flutter_sample/features/agent_place/domain/usecase/get_place_details_usecase.dart';
import 'package:flutter_sample/features/agent_place/domain/usecase/get_prediction_list_usecase.dart';
import 'package:flutter_sample/features/agent_place/presentation/cubit/place_details_api_cubit.dart';
import 'package:flutter_sample/features/agent_place/presentation/cubit/prediction_api_cubit.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart';

final sl = GetIt.instance;

setup() {
  sl.registerLazySingleton(
      () => PredictionApiCubit(getPredictionListUsecase: sl()));
  sl.registerLazySingleton(
      () => PlaceDetailsApiCubit(getPlaceDetailsUsecase: sl()));

  sl.registerLazySingleton(() => GetPredictionListUsecase(repository: sl()));
  sl.registerLazySingleton(() => GetPlaceDetailsUsecase(repository: sl()));

  sl.registerLazySingleton<AgentPlaceRepository>(
      () => AgentPlaceRepositoryImpl(remote: sl()));

  sl.registerLazySingleton<AgentPlaceRemote>(
      () => AgentPlaceRemoteImpl(client: sl()));

  sl.registerLazySingleton(() => Client());
}
