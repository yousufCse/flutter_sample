part of 'agent_location_api_cubit.dart';

abstract class AgentLocationApiState {}

class AgentLocationApiInitial extends AgentLocationApiState {}

class AgentLocationApiLoading extends AgentLocationApiState {}

class AgentLocationApiFailure extends AgentLocationApiState {
  final Object exception;

  AgentLocationApiFailure(this.exception);
}

class AgentLocationApiSuccess extends AgentLocationApiState {
  final List<AgentInfoEntity> src;

  AgentLocationApiSuccess({required this.src});
}
