import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sample/core/usecase/usecase.dart';
import 'package:flutter_sample/features/agent_location/domain/entity/agent_info_entity.dart';
import 'package:flutter_sample/features/agent_location/domain/usecase/get_agent_list_usecase.dart';

part 'agent_location_api_state.dart';

class AgentLocationApiCubit extends Cubit<AgentLocationApiState> {
  final GetAgentListUsecase getAgentListUsecase;

  AgentLocationApiCubit({required this.getAgentListUsecase})
      : super(AgentLocationApiInitial());

  void getAgentList() async {
    emit(AgentLocationApiLoading());

    try {
      final list = await getAgentListUsecase.call(NoParams());

      emit(AgentLocationApiSuccess(src: list));
    } catch (e) {
      emit(AgentLocationApiFailure(e));
    }
  }
}
