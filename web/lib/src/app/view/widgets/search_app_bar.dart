// External packages
import 'package:core/core.dart';
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
      onChanged: onChanged,
      onSubmitted: onChanged,
      decoration: InputDecoration(
        hintText: 'search_field'.i18n(),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(4)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: const BorderSide(color: ThemePalette.primary, width: 1),
        ),
        contentPadding: const EdgeInsets.all(10),
        suffixIcon: IconButton(
          onPressed: clear,
          icon: const Icon(Icons.clear),
        ),
      ),
    );
  }
}
