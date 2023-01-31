import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sample/features/location_search/data/model/prediction.dart';
import 'package:flutter_sample/features/location_search/presentation/cubit/prediction_api_cubit.dart';
import 'package:flutter_sample/features/location_search/presentation/widgets/prediction_item.dart';

class PredictionList extends StatelessWidget {
  final void Function(Prediction data) onListItemTap;

  const PredictionList({super.key, required this.onListItemTap});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PredictionApiCubit, PredictionApiState>(
      builder: (context, state) {
        if (state is PredictionApiSuccess && state.list.isNotEmpty) {
          return ListView.builder(
              itemCount: state.list.length,
              itemBuilder: (context, index) {
                final item = state.list[index];
                return PredictionItem(
                    prediction: item, onItemTap: () => onListItemTap(item));
              });
        }
        return const SizedBox();
      },
    );
  }
}
