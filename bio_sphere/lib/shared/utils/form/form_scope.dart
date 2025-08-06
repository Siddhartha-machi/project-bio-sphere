import 'package:flutter/material.dart';

import 'package:bio_sphere/shared/utils/form/form_state_manager.dart';

class FormScope extends InheritedWidget {
  final FormStateManager formManager;

  const FormScope({super.key, required super.child, required this.formManager});

  static FormStateManager of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<FormScope>();
    if (scope == null) {
      throw Exception('No FormScope found in context');
    }
    return scope.formManager;
  }

  @override
  bool updateShouldNotify(FormScope oldWidget) {
    return oldWidget.formManager != formManager;
  }
}
