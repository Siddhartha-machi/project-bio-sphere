import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';

import 'package:bio_sphere/core/routing/path_registry.dart';
import 'package:bio_sphere/shared/presentation/text/text_ui.dart';
import 'package:bio_sphere/shared/constants/widget/text_widget_enums.dart';
import 'package:bio_sphere/shared/presentation/buttons/generic_button.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          spacing: 12.0,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextUI('Bio Sphere Home', level: TextLevel.titleMedium),

            GenericButton(
              label: 'Go To Page',
              onPressed: () {
                GoRouter.of(context).push(PathRegistry.auth.root.absolutePath);
              },
            ),
          ],
        ),
      ),
    );
  }
}
