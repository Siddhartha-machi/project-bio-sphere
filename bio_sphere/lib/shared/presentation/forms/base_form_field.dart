import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:bio_sphere/shared/utils/global.dart';
import 'package:bio_sphere/shared/utils/form/form_scope.dart';
import 'package:bio_sphere/shared/presentation/text/text_ui.dart';
import 'package:bio_sphere/shared/models/generic_field_config.dart';
import 'package:bio_sphere/shared/utils/form/form_state_manager.dart';
import 'package:bio_sphere/shared/constants/widget/text_widget_enums.dart';
import 'package:bio_sphere/shared/utils/form/generic_field_controller.dart';

abstract class BaseFormField<T> extends StatefulWidget {
  final GenericFieldConfig config;

  const BaseFormField({super.key, required this.config});
}

abstract class BaseFormFieldState<T, W extends BaseFormField<T>>
    extends State<W> {
  bool _hasFocus = false;
  late final FocusNode? _focusNode;
  bool _isFormManagerInitialized = false;
  late final FormStateManager _formManager;

  /// ---------- Customization points ----------- ///
  @protected
  bool get enableFieldFocus => true;

  @protected
  double get iconSize => 16.sp;

  @protected
  FocusNode? get focusNode => _focusNode;

  /// ---------- State initialization ----------- ///
  @override
  void initState() {
    super.initState();
    if (enableFieldFocus) {
      _focusNode = FocusNode();
      _focusNode!.addListener(() {
        final hasFocus = _focusNode.hasFocus;
        if (_hasFocus != hasFocus) {
          setState(() => _hasFocus = hasFocus);
          if (!hasFocus) {
            getFieldController().validate();
          }
        }
      });
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    /// Try registering only if it hasn't been already.
    if (!_isFormManagerInitialized) {
      _formManager = FormScope.of(context);
      _isFormManagerInitialized = true;

      if (!_formManager.isRegistered(widget.config.name)) {
        _formManager.register<T>(widget.config.name, this);
      }
    }
  }

  @override
  void dispose() {
    if (enableFieldFocus) focusNode?.dispose();

    _formManager.unregister(widget.config.name);

    super.dispose();
  }

  /// ---------- UI Helpers ----------- ///
  @protected
  InputDecoration buildDecoration(GenericFieldState<T> state) {
    return InputDecoration(
      suffixIcon: buildErrorWidget(state),
      hintText: widget.config.hintText,
      error: state.error != null ? const SizedBox.shrink() : null,
    );
  }

  @protected
  Widget? buildErrorWidget(GenericFieldState<T> state) {
    if (state.error == null) return null;

    return Tooltip(
      message: state.error!,
      child: Icon(
        Icons.error,
        size: iconSize,
        color: Theme.of(context).colorScheme.error,
      ),
    );
  }

  Widget _buildFieldLabel(GenericFieldState<T> state) {
    final List<Widget> children = [];
    final theme = Theme.of(context);
    Color? color;

    if (state.error != null) {
      color = theme.colorScheme.error;
    } else if (_hasFocus) {
      color = theme.colorScheme.primary;
    }

    if (widget.config.prefixIcon != null) {
      children.add(
        Icon(
          IconData(widget.config.prefixIcon!, fontFamily: 'MaterialIcons'),
          size: iconSize,
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
      children.add(Icon(FontAwesomeIcons.asterisk, size: 8.sp, color: color));
    }

    return children.isEmpty
        ? const SizedBox.shrink()
        : Row(spacing: 5, children: children);
  }

  Widget _buildFieldWrapper(GenericFieldState<T> state) {
    return Column(
      spacing: 5,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [_buildFieldLabel(state), buildFieldUI(context, state)],
    );
  }

  /// ---------- Form interaction helpers ----------- ///
  @protected
  GenericFieldController<T> getFieldController() {
    final state = _formManager.field<T>(widget.config.name);
    if (state == null) {
      throw Exception('Field ${widget.config.name} is not registered.');
    }
    return state;
  }

  @protected
  void didChange(T? value) {
    getFieldController().didChange(value);
  }

  /// ---------- Build ----------- ///
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<GenericFieldState<T>>(
      valueListenable: getFieldController(),
      builder: (context, state, _) => _buildFieldWrapper(state),
    );
  }

  /// ---------- Abstract methods ----------- ///
  T? reset();
  String? validate(T? value);
  Widget buildFieldUI(BuildContext ctx, GenericFieldState<T> state);
}
