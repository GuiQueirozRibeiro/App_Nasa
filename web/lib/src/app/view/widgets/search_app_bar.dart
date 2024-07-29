// External packages
import 'package:flutter/material.dart';
import 'package:localization/localization.dart';

class SearchAppBar extends StatelessWidget {
  final TextEditingController controller;
  final Function(String) onChanged;

  const SearchAppBar({
    super.key,
    required this.controller,
    required this.onChanged,
  });

  void clear() {
    controller.clear();
    onChanged('');
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: 'search_field'.i18n(),
        prefixIcon: const Icon(Icons.search),
        suffixIcon: IconButton(
          onPressed: clear,
          icon: const Icon(Icons.clear),
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
      ),
      onChanged: onChanged,
      onSubmitted: onChanged,
    );
  }
}
