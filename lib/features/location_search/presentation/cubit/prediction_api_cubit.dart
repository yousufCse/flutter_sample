import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sample/features/location_search/data/model/prediction.dart';
import 'package:flutter_sample/features/location_search/domain/usecase/get_prediction_list_usecase.dart';

part 'prediction_api_state.dart';

class PredictionApiCubit extends Cubit<PredictionApiState> {
  final GetPredictionListUsecase getPredictionListUsecase;

  PredictionApiCubit({required this.getPredictionListUsecase})
      : super(PredictionApiInitial());

  void getPredictinList(String place) async {
    emit(PredictionApiLoading());

    try {
      final data = await getPredictionListUsecase.call(place);

      emit(PredictionApiSuccess(data));
    } catch (e) {
      emit(PredictionApiFailure(e));
    }
  }

  void removePredictionList() {
    emit(PredictionApiInitial());
  }
}
