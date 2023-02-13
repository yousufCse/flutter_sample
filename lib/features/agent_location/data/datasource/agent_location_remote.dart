import 'dart:convert';

import 'package:flutter_sample/features/agent_location/data/model/agent_list_response_model.dart';
import 'package:http/http.dart';

abstract class AgentLocationRemote {
  Future<AgentListResponseModel> getAgentList();
}

class AgentLocationRemoteImpl implements AgentLocationRemote {
  final Client client;

  const AgentLocationRemoteImpl({required this.client});

  @override
  Future<AgentListResponseModel> getAgentList() async {
    final url = Uri.parse(
        'https://e3zg9.mocklab.io/json/get-agent-locaton-list'); //* Place URL here

    final response =
        await client.get(url, headers: {'Content-Type': 'application/json'});

    if (response.statusCode == 200) {
      final responseModel =
          AgentListResponseModel.fromJson(json.decode(response.body));

      return responseModel;
    } else {
      throw Exception();
    }
  }
}
