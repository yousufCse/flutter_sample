
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sample/features/agent_location/domain/entity/agent_info_entity.dart';

part 'marker_item_tap_state.dart';

class MarkerItemTapCubit extends Cubit<MarkerItemTapState> {
  MarkerItemTapCubit() : super(MarkerItemTapInitial());

  void onMarkerTap(AgentInfoEntity entity) async {
    tapItemClear();
    emit(MarkerItemTapFired(entity));
  }

  void tapItemClear() {
    emit(MarkerItemTapInitial());
  }
}
