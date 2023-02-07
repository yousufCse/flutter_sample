import 'package:flutter_sample/features/agent_location/data/model/agent_info_model.dart';

class AgentListResponseModel {
  final List<AgentInfoModel> data;

  AgentListResponseModel({required this.data});

  factory AgentListResponseModel.fromJson(List list) {
    return AgentListResponseModel(
        data: list.map((e) => AgentInfoModel.fromJson(e)).toList());
  }
}
