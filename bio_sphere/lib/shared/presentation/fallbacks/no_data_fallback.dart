import 'package:flutter/material.dart';

import 'package:bio_sphere/shared/presentation/text/text_ui.dart';

class NoDataFallback extends StatelessWidget {
  final String message;

  const NoDataFallback({super.key, required this.message});

  @override
  Widget build(BuildContext context) => Center(child: TextUI(message));
}
