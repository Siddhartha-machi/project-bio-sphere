import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:bio_sphere/shared/presentation/forms/base_form_field.dart';
import 'package:bio_sphere/shared/utils/form/generic_field_controller.dart';

class CustomTextField extends BaseFormField<String> {
  const CustomTextField({super.key, required super.config});

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState
    extends BaseFormFieldState<String, CustomTextField> {
  late final TextEditingController _textController;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController();

    Future.microtask(() {
      final controller = getFieldController();
      controller.addListener(() {
        if (controller.data != _textController.text) {
          _textController.text = controller.data ?? '';
        }
      });
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  String? reset() => '';

  @override
  String? validate(String? value) {
    String? error;

    /// TODO : Refactor

    if (value == null || value.isEmpty) {
      error = 'Field is required';
    }

    return error;
  }

  @override
  Widget buildFieldUI(BuildContext ctx, GenericFieldState<String> state) {
    return TextField(
      onChanged: didChange,
      focusNode: focusNode,
      controller: _textController,
      maxLines: widget.config.rows,
      minLines: widget.config.rows,
      style: TextStyle(fontSize: 12.sp),
      decoration: buildDecoration(state),
    );
  }
}
