import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:bio_sphere/models/widget_models/generic_field_config.dart';
import 'package:bio_sphere/shared/utils/form/generic_field_controller.dart';

class CustomTextField extends StatefulWidget {
  final GenericFieldController<String> controller;

  const CustomTextField(this.controller, {super.key});

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late final TextEditingController _textController;

  GenericFieldConfig _config() => widget.controller.config;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController();

    widget.controller.addListener(() {
      if (widget.controller.data != _textController.text) {
        _textController.text = widget.controller.data ?? '';
      }
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext ctx) {
    final config = _config();

    return TextField(
      maxLines: config.rows,
      minLines: config.rows,
      controller: _textController,
      decoration: InputDecoration(
        border: InputBorder.none,
        hintText: config.hintText,
        fillColor: Colors.transparent,
        enabledBorder: InputBorder.none,
      ),
      style: TextStyle(fontSize: 12.sp),
      onChanged: widget.controller.didChange,
      obscureText: config.type == GenericFieldType.password,
    );
  }
}
