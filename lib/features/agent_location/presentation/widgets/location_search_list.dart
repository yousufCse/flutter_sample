import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sample/features/agent_location/domain/entity/agent_info_entity.dart';
import 'package:flutter_sample/features/agent_location/presentation/cubit/search/location_search_cubit.dart';
import 'package:flutter_sample/features/agent_location/presentation/widgets/location_search_emtpy_widget.dart';
import 'package:flutter_sample/features/agent_location/presentation/widgets/location_search_item.dart';

class LocationSearchList extends StatelessWidget {
  final Function(AgentInfoEntity data) onListItemTap;

  const LocationSearchList({required this.onListItemTap, super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LocationSearchCubit, LocationSearchState>(
      buildWhen: (previous, current) {
        return previous.searchState != current.searchState;
      },
      builder: (context, state) {
        final searchState = state.searchState;

        if (searchState is SearchStateHasData) {
          final list = searchState.list;
          return ListView.builder(
            itemCount: list.length,
            itemBuilder: (context, index) {
              final item = list[index];
              return LocationSearchItem(
                  data: item, onItemTap: () => onListItemTap(item));
            },
          );
        } else if (searchState is SearchStateNoData) {
          return const LocationSearchEmptyWidget();
        }

        return const SizedBox();
      },
    );
  }
}
