import 'package:flutter/material.dart';

import 'package:icons_plus/icons_plus.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:bio_sphere/shared/presentation/text/text_ui.dart';
import 'package:bio_sphere/shared/constants/widget/text_widget_enums.dart';

/// A customizable expansion tile widget.
class CustomExpansionTile extends StatefulWidget {
  /// Initial expanded state
  final bool isExpanded;

  /// The main title widget.
  final String title;

  /// The subtitle widget below the title.
  final String? subtitle;

  /// A widget to display before the title (e.g., an icon).
  final Widget? leading;

  /// The background color of the header.
  final Color? headerColor;

  /// Padding for the header section.
  final (double, double) headerPadding;

  /// Padding for the body section.
  final (double, double, double, double) contentPadding;

  /// Content border attribute
  final bool enableContentBorder;

  /// The children widgets to display when expanded.
  final Widget child;

  const CustomExpansionTile({
    super.key,
    this.subtitle,
    this.leading,
    this.headerColor,
    required this.child,
    required this.title,
    this.isExpanded = false,
    this.headerPadding = (5, 10),
    this.contentPadding = (8, 8, 8, 8),
    this.enableContentBorder = true,
  });

  @override
  State<CustomExpansionTile> createState() => _CustomExpansionTileState();
}

class _CustomExpansionTileState extends State<CustomExpansionTile>
    with SingleTickerProviderStateMixin {
  late bool _isExpanded;
  late final Animation<double> _size;
  late final Animation<double> _iconTurns;
  late final AnimationController _controller;

  /// -------------- Life cycle overrides -------------- ///
  @override
  void initState() {
    super.initState();

    _isExpanded = widget.isExpanded;

    /// Animation controller for expansion/collapse.
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _size = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
    _iconTurns = Tween<double>(begin: 0.0, end: 0.5).animate(_size);

    // If isExpanded set initially, show the expanded view
    if (_isExpanded) {
      _controller.value = 1.0;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// -------------- Utility methods -------------- ///

  /// Toggles the expanded/collapsed state.
  void _toggle() {
    setState(() => _isExpanded = !_isExpanded);
    if (_isExpanded) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  /// Builds the header row with title, subtitle, leading, and expand icon.
  Widget _buildHeader(BuildContext ctx) {
    final color = Theme.of(ctx).colorScheme.onPrimary;

    return Row(
      children: [
        if (widget.leading != null) widget.leading!,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextUI(widget.title, color: color),
              if (widget.subtitle != null)
                TextUI(
                  color: color,
                  widget.subtitle!,
                  level: TextLevel.labelSmall,
                ),
            ],
          ),
        ),

        // Rotating expand/collapse icon.
        RotationTransition(
          turns: _iconTurns,
          child: Icon(
            size: 14.sp,
            color: color,
            FontAwesome.circle_chevron_up_solid,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final contentBorderColor = theme.disabledColor.withAlpha(50);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        /// Header section with color and padding.
        GestureDetector(
          onTap: _toggle,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(4.sp),
                topRight: Radius.circular(4.sp),
                bottomLeft: _isExpanded ? Radius.zero : Radius.circular(4.sp),
                bottomRight: _isExpanded ? Radius.zero : Radius.circular(4.sp),
              ),
              border: Border.all(color: theme.primaryColor),
              color:
                  widget.headerColor ??
                  theme.colorScheme.primary.withAlpha(185),
            ),
            padding: EdgeInsets.symmetric(
              vertical: widget.headerPadding.$1.sp,
              horizontal: widget.headerPadding.$2.sp,
            ),
            child: _buildHeader(context),
          ),
        ),

        // Main widget structure.
        AnimatedBuilder(
          animation: _size,
          builder: (context, child) =>
              SizeTransition(sizeFactor: _size, child: child),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(4.sp),
                bottomRight: Radius.circular(4.sp),
              ),
              border: widget.enableContentBorder
                  ? Border(
                      left: BorderSide(color: contentBorderColor),
                      right: BorderSide(color: contentBorderColor),
                      bottom: BorderSide(color: contentBorderColor),
                    )
                  : null,
            ),
            padding: EdgeInsets.fromLTRB(
              widget.contentPadding.$1.sp,
              widget.contentPadding.$2.sp,
              widget.contentPadding.$3.sp,
              widget.contentPadding.$4.sp,
            ),
            child: widget.child,
          ),
        ),
      ],
    );
  }
}
