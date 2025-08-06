import 'package:flutter/material.dart';

import 'package:bio_sphere/shared/utils/form/form_scope.dart';
import 'package:bio_sphere/shared/utils/form/form_state_manager.dart';

class FormProvider extends StatefulWidget {
  final Widget child;

  const FormProvider({super.key, required this.child});

  @override
  State<FormProvider> createState() => FormProviderState();

  static FormStateManager of(BuildContext context) => FormScope.of(context);
}

class FormProviderState extends State<FormProvider> {
  late final FormStateManager formManager;

  @override
  void initState() {
    super.initState();
    formManager = FormStateManager();
  }

  @override
  void dispose() {
    formManager.disposeAll();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FormScope(formManager: formManager, child: widget.child);
  }
}
