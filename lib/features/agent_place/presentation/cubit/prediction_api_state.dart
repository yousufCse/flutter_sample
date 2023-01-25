part of 'prediction_api_cubit.dart';

abstract class PredictionApiState {}

class PredictionApiInitial extends PredictionApiState {}

class PredictionApiLoading extends PredictionApiState {}

class PredictionApiFailure extends PredictionApiState {
  final Object exception;
  PredictionApiFailure(this.exception);
}

class PredictionApiSuccess extends PredictionApiState {
  final List<Prediction> list;

  PredictionApiSuccess(this.list);
}
