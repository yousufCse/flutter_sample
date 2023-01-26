import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sample/features/location_search/data/model/place/place_details.dart';
import 'package:flutter_sample/features/location_search/domain/usecase/get_place_details_usecase.dart';

part 'place_details_api_state.dart';

class PlaceDetailsApiCubit extends Cubit<PlaceDetailsApiState> {
  final GetPlaceDetailsUsecase getPlaceDetailsUsecase;

  PlaceDetailsApiCubit({required this.getPlaceDetailsUsecase})
      : super(PlaceDetailsApiInitial());

  void getPlaceDetails(String placeId) async {
    emit(PlaceDetailsApiLoading());

    try {
      final data = await getPlaceDetailsUsecase.call(placeId);

      emit(PlaceDetailsApiSuccess(data));
    } catch (e) {
      emit(PlaceDetailsApiFailure(e));
    }
  }
}
