part of 'place_details_api_cubit.dart';

abstract class PlaceDetailsApiState {}

class PlaceDetailsApiInitial extends PlaceDetailsApiState {}

class PlaceDetailsApiLoading extends PlaceDetailsApiState {}

class PlaceDetailsApiFailure extends PlaceDetailsApiState {
  final Object exception;
  PlaceDetailsApiFailure(this.exception);
}

class PlaceDetailsApiSuccess extends PlaceDetailsApiState {
  final PlaceDetails place;

  PlaceDetailsApiSuccess(this.place);
}
