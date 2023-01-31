import 'package:flutter_sample/features/location_search/data/datasource/location_search_remote.dart';
import 'package:flutter_sample/features/location_search/data/repository/location_search_repository_impl.dart';
import 'package:flutter_sample/features/location_search/domain/repository/location_search_repository.dart';
import 'package:flutter_sample/features/location_search/domain/usecase/get_place_details_usecase.dart';
import 'package:flutter_sample/features/location_search/domain/usecase/get_prediction_list_usecase.dart';
import 'package:flutter_sample/features/location_search/presentation/cubit/agent_info_api_cubit.dart';
import 'package:flutter_sample/features/location_search/presentation/cubit/place_details_api_cubit.dart';
import 'package:flutter_sample/features/location_search/presentation/cubit/prediction_api_cubit.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart';

final sl = GetIt.instance;

setup() {
  sl.registerLazySingleton(
      () => PredictionApiCubit(getPredictionListUsecase: sl()));
  sl.registerLazySingleton(
      () => PlaceDetailsApiCubit(getPlaceDetailsUsecase: sl()));
  sl.registerLazySingleton(() => AgentInfoApiCubit());

  sl.registerLazySingleton(() => GetPredictionListUsecase(repository: sl()));
  sl.registerLazySingleton(() => GetPlaceDetailsUsecase(repository: sl()));

  sl.registerLazySingleton<LocationSearchRepository>(
      () => LocationSearchRepositoryImpl(remote: sl()));

  sl.registerLazySingleton<LocationSearchRemote>(
      () => LocationSearchRemoteImpl(client: sl()));

  sl.registerLazySingleton(() => Client());
}
