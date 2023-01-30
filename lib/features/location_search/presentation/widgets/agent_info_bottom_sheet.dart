import 'package:flutter/material.dart';
import 'package:flutter_sample/features/location_search/presentation/screen/agent_info.dart';

class AgentInfoBottomSheet extends StatelessWidget {
  final AgentInfo data;

  const AgentInfoBottomSheet({
    required this.data,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 15, right: 10),
      height: 200,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text(
              data.name,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.close))
          ]),
          Text(data.details),
          const SizedBox(height: 10),
          Text(data.address),
          const SizedBox(height: 10),
          Text(data.hyperlink,
              style: const TextStyle(
                  color: Colors.blue, fontStyle: FontStyle.italic)),
        ],
      ),
    );
  }
}
