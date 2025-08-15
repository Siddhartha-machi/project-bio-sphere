import 'package:flutter/material.dart';

import 'package:icons_plus/icons_plus.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:bio_sphere/shared/utils/global.dart';
import 'package:bio_sphere/shared/utils/form/form_scope.dart';
import 'package:bio_sphere/shared/presentation/text/text_ui.dart';
import 'package:bio_sphere/models/widget_models/generic_field_config.dart';
import 'package:bio_sphere/shared/constants/widget/text_widget_enums.dart';
import 'package:bio_sphere/shared/utils/form/generic_field_controller.dart';

class FieldWrap<T> extends StatefulWidget {
  final bool withFocus;
  final bool withWrapper;
  final GenericFieldConfig config;
  final Widget Function(GenericFieldController<T>) builder;

  const FieldWrap({
    super.key,
    required this.config,
    required this.builder,
    this.withFocus = false,
    this.withWrapper = false,
  });

  @override
  State<FieldWrap<T>> createState() => _FieldWrapState<T>();
}

class _FieldWrapState<T> extends State<FieldWrap<T>> {
  FocusNode? _focusNode;

  /// ---------- State life cycle methods ----------- ///
  @override
  void initState() {
    super.initState();
    if (widget.withFocus) {
      _focusNode = FocusNode();
    }
  }

  @override
  void dispose() {
    _focusNode?.dispose();
    super.dispose();
  }

  /// ---------- UI Helpers ----------- ///
  Widget _buildFieldLabel(
    BuildContext ctx,
    GenericFieldState<T> state,
    bool hasFocus,
  ) {
    final theme = Theme.of(ctx);
    Color? color;

    if (state.error != null) {
      color = theme.colorScheme.error;
    } else if (hasFocus) {
      color = theme.colorScheme.primary;
    }

    final children = <Widget>[];
    if (widget.config.prefixIcon != null) {
      children.add(
        Icon(
          IconData(widget.config.prefixIcon!, fontFamily: 'MaterialIcons'),
          size: 16.sp,
          color: color,
        ),
      );
    }

    if (!Global.isEmptyString(widget.config.label)) {
      children.add(
        TextUI(widget.config.label!, level: TextLevel.labelSmall, color: color),
      );
    }

    if (widget.config.isRequired) {
      children.add(Icon(FontAwesome.asterisk_solid, size: 7.sp, color: color));
    }

    return children.isEmpty
        ? const SizedBox.shrink()
        : Padding(
            padding: EdgeInsets.only(left: 2.sp, right: 3.sp),
            child: Row(spacing: 5, children: children),
          );
  }

  Widget _buildErrorWidget(BuildContext ctx, GenericFieldState<T> state) {
    final color = Theme.of(ctx).colorScheme.error;
    return Tooltip(
      message: state.error!,
      child: Icon(FontAwesome.circle_info_solid, color: color, size: 13.sp),
    );
  }

  Border _buildBorderFromState(
    BuildContext ctx,
    GenericFieldState<T> state,
    bool hasFocus,
  ) {
    if (state.error != null) {
      return Border.all(color: Theme.of(ctx).colorScheme.error);
    }
    if (hasFocus) {
      return Border.all(color: Theme.of(ctx).colorScheme.primary);
    }
    return Border.all(
      color: Theme.of(
        ctx,
      ).inputDecorationTheme.enabledBorder!.borderSide.color.withAlpha(100),
    );
  }

  /// ---------- Utility methods ----------- ///
  void _focusHandler(bool hasFocus, GenericFieldController<T> controller) {
    setState(() {});
    if (!hasFocus) controller.validate();
  }

  GenericFieldController<T>? _mayGetController(BuildContext ctx) {
    final controller = FormScope.of(ctx).field<T>(widget.config.name);

    return controller;
  }

  Widget _buildField(
    BuildContext ctx,
    GenericFieldController<T> controller,
    GenericFieldState<T> state,
  ) {
    return Column(
      spacing: 5,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: _buildFieldLabel(
                ctx,
                state,
                _focusNode?.hasFocus ?? false,
              ),
            ),
            if (state.error != null) _buildErrorWidget(ctx, state),
          ],
        ),

        widget.withWrapper
            ? Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6.sp),
                  border: _buildBorderFromState(
                    ctx,
                    state,
                    _focusNode?.hasFocus ?? false,
                  ),
                ),
                child: widget.builder(controller),
              )
            : widget.builder(controller),

        if (!Global.isEmptyString(controller.config.helperText))
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 3.sp),
            child: TextUI(
              level: TextLevel.caption,
              controller.config.helperText!,
            ),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = _mayGetController(context);

    if (controller == null) {
      return TextUI('Unable to render ${widget.config.name} field');
    }

    return ValueListenableBuilder<GenericFieldState<T>>(
      valueListenable: controller,
      builder: (ctx, state, _) {
        return widget.withFocus
            ? Focus(
                focusNode: _focusNode,
                onFocusChange: (hasFocus) =>
                    _focusHandler(hasFocus, controller),
                child: _buildField(ctx, controller, state),
              )
            : _buildField(ctx, controller, state);
      },
    );
  }
}
