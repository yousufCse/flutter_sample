import 'package:flutter/material.dart';
import 'package:flutter_sample/features/agent_place/data/model/prediction.dart';

class PredictionItem extends StatelessWidget {
  final Prediction prediction;

  final VoidCallback onItemTap;

  const PredictionItem({
    required this.prediction,
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
              prediction.description,
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
