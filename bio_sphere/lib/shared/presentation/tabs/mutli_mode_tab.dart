import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

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

    _child = widget.builder(); // Built only once
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 8.sp),
      child: _child,
    );
  }
}
