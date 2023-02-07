import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sample/features/agent_location/domain/entity/agent_info_entity.dart';

part 'location_search_state.dart';

class LocationSearchCubit extends Cubit<LocationSearchState> {
  LocationSearchCubit() : super(LocationSearchInitial());

  void searchLocation(String value, List<AgentInfoEntity> agentInfoList) {
    emit(LocationSearchInitial());

    final input = value.toLowerCase().trim();

    final List<AgentInfoEntity> filteredList = [];

    if (input.isEmpty) {
      emit(LocationSearchInitial());
      return;
    }

    for (var i in agentInfoList) {
      if (i.address.toLowerCase().contains(input)) {
        filteredList.add(i);
      }
    }

    if (filteredList.isNotEmpty) {
      emit(LoationSearchHasData(filteredList));
    } else {
      emit(LocationSearchNoData());
    }
  }

  void setToInitialState() {
    emit(LocationSearchInitial());
  }
}
