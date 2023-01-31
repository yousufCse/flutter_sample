part of 'agent_info_api_cubit.dart';

abstract class AgentInfoApiState {}

class AgentInfoApiInitial extends AgentInfoApiState {}

class AgentInfoApiLoading extends AgentInfoApiState {}

class AgentInfoApiFailure extends AgentInfoApiState {
  final Object exception;

  AgentInfoApiFailure(this.exception);
}

class AgentInfoApiSuccess extends AgentInfoApiState {
  final List<AgentInfo> src;

  AgentInfoApiSuccess({required this.src});
}
