import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sample/features/agent_location/domain/entity/agent_info_entity.dart';
import 'package:flutter_sample/features/agent_location/presentation/cubit/location_search_cubit.dart';
import 'package:flutter_sample/features/agent_location/presentation/widgets/location_search_emtpy_widget.dart';
import 'package:flutter_sample/features/agent_location/presentation/widgets/location_search_item.dart';

class LocationSearchList extends StatelessWidget {
  final Function(AgentInfoEntity data) onListItemTap;

  const LocationSearchList({required this.onListItemTap, super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LocationSearchCubit, LocationSearchState>(
      builder: (context, state) {
        if (state is LoationSearchHasData) {
          return ListView.builder(
            itemCount: state.src.length,
            itemBuilder: (context, index) {
              final item = state.src[index];
              return LocationSearchItem(
                  data: item, onItemTap: () => onListItemTap(item));
            },
          );
        } else if (state is LocationSearchNoData) {
          return const LocationSearchEmptyWidget();
        }

        return const SizedBox();
      },
    );
  }
}
