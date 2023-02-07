import 'package:flutter/material.dart';
import 'package:flutter_sample/features/agent_location/domain/entity/agent_info_entity.dart';


class LocationSearchItem extends StatelessWidget {
  final AgentInfoEntity data;

  final VoidCallback onItemTap;

  const LocationSearchItem({
    required this.data,
    required this.onItemTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          color: Colors.white,
          child: ListTile(
            horizontalTitleGap: 0,
            onTap: onItemTap,
            leading: const Icon(Icons.location_on_outlined),
            title: Text(
              data.address,
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
              style: const TextStyle(fontSize: 18),
            ),
          ),
        ),
        Divider(
          height: 1,
          thickness: 1,
          color: Colors.grey[100],
        )
      ],
    );
  }
}