import 'dart:async';
import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sample/features/location_search/presentation/screen/agent_info.dart';

part 'agent_info_api_state.dart';

class AgentInfoApiCubit extends Cubit<AgentInfoApiState> {
  AgentInfoApiCubit() : super(AgentInfoApiInitial());

  void getAgentInfos() async {
    emit(AgentInfoApiLoading());

    try {
      // fetch data from server
      await Future.delayed(const Duration(seconds: 2), () {});
      final list = generateAgentList();
      emit(AgentInfoApiSuccess(src: list));
    } catch (e) {
      emit(AgentInfoApiFailure(e));
    }
  }

  List<AgentInfo> generateAgentList() {
    List<AgentInfo> list = [];

    for (int i = 0; i < 2000; i++) {
      final id = '${i + 1}';

      var random = Random();

      final mainLat = 23.7275664 + (random.nextInt(2000) / 10000);
      final mainLng = 90.2990201 + (random.nextInt(2000) / 10000);

      list.add(AgentInfo(
          id: id,
          name: 'Agent Name $id',
          details: 'Agent Details $id',
          address: '#$id House, Road A, Location, Dhaka',
          hyperlink: 'https://jsonplaceholder.typicode.com/todos/$id',
          lat: mainLat,
          lng: mainLng));
    }

    return list;
  }
}
