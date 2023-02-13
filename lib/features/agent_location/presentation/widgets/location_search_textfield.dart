import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sample/core/constants.dart';
import 'package:flutter_sample/features/agent_location/presentation/cubit/search/location_search_cubit.dart';

class LocationSearchTextField extends StatelessWidget {
  final Function(String value) onChanged;
  final VoidCallback onTapClear;

  LocationSearchTextField({
    required this.onChanged,
    required this.onTapClear,
    super.key,
  });

  final TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LocationSearchCubit, LocationSearchState>(
      buildWhen: (previous, current) {
        return previous.searchValue != current.searchValue;
      },
      builder: (context, state) {
        controller.text = state.searchValue;
        controller.selection =
            TextSelection.collapsed(offset: controller.text.length);

        return Container(
          margin:
              const EdgeInsets.only(left: 15, right: 15, bottom: 5, top: 10),
          padding: const EdgeInsets.only(left: 10, right: 0),
          decoration: BoxDecoration(
              color: Colors.grey[100], borderRadius: BorderRadius.circular(25)),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: controller,
                  onChanged: onChanged,
                  decoration: const InputDecoration(
                    hintText: Constants.searchHint,
                    border: InputBorder.none,
                  ),
                ),
              ),
              state.searchValue.isEmpty
                  ? const IconButton(onPressed: null, icon: Icon(Icons.search))
                  : IconButton(
                      onPressed: onTapClear, icon: const Icon(Icons.clear))
            ],
          ),
        );
      },
    );
  }
}
