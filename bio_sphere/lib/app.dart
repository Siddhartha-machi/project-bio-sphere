import 'package:flutter/material.dart';

import 'package:bio_sphere/ui_test_dev/text_visual_test.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          spacing: 12.0,
          children: [
            TextVisualTest(),

            /// Testing widgets
          ],
        ),
      ),
    );
  }
}
