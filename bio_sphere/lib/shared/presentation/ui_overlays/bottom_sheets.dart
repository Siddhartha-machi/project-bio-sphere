import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:bio_sphere/shared/utils/style.dart';
import 'package:bio_sphere/shared/presentation/text/text_ui.dart';
import 'package:bio_sphere/shared/constants/widget/text_widget_enums.dart';

class BottomSheets {
  static Widget _buildModelHeader(BuildContext ctx, String title) {
    return Container(
      padding: EdgeInsets.only(left: 12.sp),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Theme.of(ctx).disabledColor.withAlpha(40)),
        ),
      ),
      child: Row(
        children: [
          Expanded(child: TextUI(title, level: TextLevel.labelMedium)),
          IconButton(
            icon: Icon(Icons.close, size: 18.sp),
            onPressed: () => Navigator.of(ctx).pop(),
          ),
        ],
      ),
    );
  }

  /// Bottom sheet for forms / small content.
  /// - Header is sticky (title + close).
  /// - Content is wrapped in SingleChildScrollView and respects keyboard insets.
  /// - FOR FORMS: ensure you pass a Column with `mainAxisSize: MainAxisSize.min`.
  static Future<T?> showBottomSheet<T>({
    required String title,
    required BuildContext context,
    required WidgetBuilder builder,
    double maxHeightFactor = 0.95,
  }) {
    final radius = Style.themeBorderRadius(context);

    return showModalBottomSheet<T>(
      context: context,
      useSafeArea: true,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        final mq = MediaQuery.of(ctx);
        final maxHeight = mq.size.height * maxHeightFactor;

        return Container(
          constraints: BoxConstraints(maxHeight: maxHeight),
          decoration: BoxDecoration(
            color: Theme.of(ctx).canvasColor,
            borderRadius: BorderRadius.vertical(top: Radius.circular(radius)),
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Sticky header
              _buildModelHeader(ctx, title),
              // Body (scrollable if needed)
              builder(ctx),
              // SingleChildScrollView(
              //   padding: EdgeInsets.only(bottom: mq.viewInsets.bottom),
              //   child: 
              // ),
            ],
          ),
        );
      },
    );
  }

  /// Draggable bottom sheet optimized for long scrollable lists.
  /// - Provides a ScrollController to the child builder which the list MUST use.
  /// - Sticky header + scrollable content that uses the provided controller.
  /// - Use this for long lists you want to drag/expand.
  static Future<T?> showDraggableListBottomSheet<T>({
    Widget? footer,
    required String title,
    double childHeightRatio = 0.45,
    required BuildContext context,
    EdgeInsetsGeometry cPadding = const EdgeInsets.all(0.0),
    required Widget Function(BuildContext, ScrollController) builder,
    EdgeInsetsGeometry cMargin = const EdgeInsets.fromLTRB(12, 0, 12, 32),
  }) {
    final radius = Style.themeBorderRadius(context);

    return showModalBottomSheet<T>(
      context: context,
      useSafeArea: true,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return DraggableScrollableSheet(
          expand: false,
          minChildSize: childHeightRatio,
          maxChildSize: childHeightRatio,
          initialChildSize: childHeightRatio,
          builder: (context, scrollController) {
            return Container(
              margin: cMargin,
              padding: cPadding,
              decoration: BoxDecoration(
                color: Theme.of(context).canvasColor,
                borderRadius: BorderRadius.circular(radius),
              ),
              child: Column(
                spacing: 18.0,
                children: [
                  // Sticky header
                  _buildModelHeader(ctx, title),

                  // Scrollable content that MUST use the provided controller
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      child: builder(ctx, scrollController),
                    ),
                  ),

                  if (footer != null) footer,
                ],
              ),
            );
          },
        );
      },
    );
  }
}
