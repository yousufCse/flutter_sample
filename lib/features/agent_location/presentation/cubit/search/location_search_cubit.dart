import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sample/core/debouncer.dart';
import 'package:flutter_sample/features/agent_location/domain/entity/agent_info_entity.dart';

part 'location_search_state.dart';

class LocationSearchCubit extends Cubit<LocationSearchState> {
  LocationSearchCubit() : super(LocationSearchState.initial());

  final Debouncer debouncer = Debouncer(milliseconds: 500);

  void onSearchValueChanged(String value, List<AgentInfoEntity> list) {
    emit(state.copyWith(searchValue: value));

    debouncer.run(() {
      _searchLocation(value, list);
    });
  }

  void _searchLocation(String value, List<AgentInfoEntity> agentInfoList) {
    final input = value.toLowerCase().trim();

    final List<AgentInfoEntity> filteredList = [];

    if (input.isEmpty) {
      emit(state.copyWith(searchState: SearchStateInitial()));
      return;
    }

    for (var i in agentInfoList) {
      if (i.address.toLowerCase().contains(input)) {
        filteredList.add(i);
      }
    }

    if (filteredList.isNotEmpty) {
      emit(state.copyWith(searchState: SearchStateHasData(filteredList)));
    } else {
      emit(state.copyWith(searchState: SearchStateNoData()));
    }
  }

  void setToInitialStateWithSearchValue(String input) {
    emit(state.copyWith(searchValue: input, searchState: SearchStateInitial()));
  }
}
