import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

Widget buildTestWidget(WidgetBuilder builder) {
  return MaterialApp(
    home: Scaffold(body: Builder(builder: builder)),
    builder: (context, child) => ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      builder: (context, _) => child!,
    ),
  );
}
