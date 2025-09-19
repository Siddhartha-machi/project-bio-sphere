import 'package:flutter/material.dart';

import 'package:bio_sphere/shared/presentation/text/text_ui.dart';

class ErrorFallback extends StatelessWidget {
  final String message;

  const ErrorFallback({super.key, required this.message});

  @override
  Widget build(BuildContext context) => Center(
    child: TextUI(
      "Error: $message",
      color: Theme.of(context).colorScheme.error,
    ),
  );
}
