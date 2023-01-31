import 'package:flutter/material.dart';
import 'package:flutter_sample/core/constants.dart';

class LocationSearchField extends StatelessWidget {
  final TextEditingController controller;

  final Function(String value) onChanged;
  final VoidCallback onTapClear;

  const LocationSearchField({
    required this.controller,
    required this.onChanged,
    required this.onTapClear,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 15, right: 15, bottom: 5, top: 10),
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
                  hintText: Constants.searchHint, border: InputBorder.none),
            ),
          ),
          controller.text.trim().isEmpty
              ? const IconButton(onPressed: null, icon: Icon(Icons.search))
              : IconButton(onPressed: onTapClear, icon: const Icon(Icons.clear))
        ],
      ),
    );
  }
}
