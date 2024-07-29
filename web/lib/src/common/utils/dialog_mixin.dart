// External packages
import 'package:flutter/material.dart';

mixin DialogMixin<T extends StatefulWidget> on State<T> {
  showSnackBar(String content) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(content),
        ),
      );
  }

  Widget showNoItemsMessage(
    String title,
    String subtitle,
    void Function() onPressed,
  ) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          onPressed: onPressed,
          icon: const Icon(Icons.refresh, size: 48),
        ),
        const SizedBox(height: 16),
        Text(
          title,
          style: const TextStyle(fontSize: 22),
        ),
        const SizedBox(height: 8),
        Text(
          subtitle,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 14),
        ),
      ],
    );
  }
}
