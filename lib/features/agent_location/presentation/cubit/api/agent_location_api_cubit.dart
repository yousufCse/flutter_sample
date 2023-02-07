import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sample/core/usecase/usecase.dart';
import 'package:flutter_sample/features/agent_location/data/model/agent_info_model.dart';
import 'package:flutter_sample/features/agent_location/domain/entity/agent_info_entity.dart';
import 'package:flutter_sample/features/agent_location/domain/usecase/get_agent_list_usecase.dart';

part 'agent_location_api_state.dart';

class AgentLocationApiCubit extends Cubit<AgentLocationApiState> {
  final GetAgentListUsecase getAgentListUsecase;

  AgentLocationApiCubit({required this.getAgentListUsecase})
      : super(AgentLocationApiInitial());

  void getAgentInfos() async {
    emit(AgentLocationApiLoading());

    try {
      // fetch data from server
      final list = await getAgentListUsecase.call(NoParams());
      debugPrint('list length: ${list.length}');

      // await Future.delayed(const Duration(seconds: 5), () {});
      // final list = generateAgentList();
      // const list = agentInfoDummyDataList;

      emit(AgentLocationApiSuccess(src: list));
    } catch (e) {
      emit(AgentLocationApiFailure(e));
    }
  }

  List<AgentInfoModel> generateAgentList() {
    List<AgentInfoModel> list = [];

    for (int i = 0; i < 2000; i++) {
      final id = '${i + 1}';

      var random = Random();

      final mainLat = 23.7275664 + (random.nextInt(2000) / 10000);
      final mainLng = 90.2990201 + (random.nextInt(2000) / 10000);

      list.add(AgentInfoModel(
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
