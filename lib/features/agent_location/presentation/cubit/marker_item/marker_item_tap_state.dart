part of 'marker_item_tap_cubit.dart';

abstract class MarkerItemTapState extends Equatable {
  const MarkerItemTapState();
}

class MarkerItemTapInitial extends MarkerItemTapState {
  @override
  List<Object?> get props => [];
}

class MarkerItemTapFired extends MarkerItemTapState {
  final AgentInfoEntity entity;

  const MarkerItemTapFired(this.entity);

  @override
  List<Object> get props => [entity];
}
