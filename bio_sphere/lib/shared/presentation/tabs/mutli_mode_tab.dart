import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

import 'package:icons_plus/icons_plus.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:bio_sphere/shared/presentation/text/text_ui.dart';

class MultiModeTab extends StatefulWidget {
  final Widget Function() builder;

  const MultiModeTab({super.key, required this.builder});

  @override
  State<MultiModeTab> createState() => _MultiModeTabState();
}

class _MultiModeTabState extends State<MultiModeTab>
    with AutomaticKeepAliveClientMixin {
  late final Widget _child;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    try {
      _child = _buildChild(); // Built only once
    } catch (err) {
      _child = _errorFallback(err);
    }
  }

  /// TODO : refactor to a global handler
  Widget _errorFallback(err) {
    return Column(
      spacing: 12.sp,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(FontAwesome.triangle_exclamation_solid, color: Colors.red),
        TextUI('Unable to render the tab.'),
        if (kDebugMode) TextUI(err?.toString() ?? 'Unknown error'),
      ],
    );
  }

  Widget _buildChild() {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 8.sp),
      child: widget.builder(),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return _child;
  }
}
