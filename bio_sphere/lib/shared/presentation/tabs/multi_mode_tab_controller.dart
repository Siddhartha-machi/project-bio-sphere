import 'package:flutter/material.dart';

import 'package:bio_sphere/shared/utils/form/form_state_manager.dart';
import 'package:bio_sphere/models/widget_models/generic_field_config.dart';
import 'package:bio_sphere/shared/utils/form/form_registration_manager.dart';

class MultiModeTabController {
  final TabController tabController;
  final Map<String, dynamic> initialValues;
  final List<List<GenericFieldConfig>> configs;
  final List<FormStateManager> _formControllers = [];

  MultiModeTabController({
    required this.configs,
    required this.tabController,
    this.initialValues = const {},
  }) {
    _initializeController();
  }

  void _initializeController() {
    for (final config in configs) {
      /// Create a registration manager to do register etc
      final registrationManager = FormRegistrationManager(
        configList: config,
        initialValues: {},
      );

      /// Form registers all fields with initial values filled if any provided.
      final formManager = registrationManager.registerForm();

      /// For every form add a manager with fields registered.
      _formControllers.add(formManager);
    }
  }

  validateAllTabs() {
    for (int index = 0; index < configs.length; index++) {
      /// If the tab is not loaded, do it before validating

      final isTabValid = _formControllers[index].validateAll();

      if (!isTabValid) {
        if (index != tabController.index) {
          tabController.animateTo(index);
        }
        break;
      }
    }
  }

  FormStateManager getTabFormManager(int index) => _formControllers[index];

  /// Life cycle
  disposeManagers() {
    for (final controller in _formControllers) {
      controller.disposeAll();
    }
  }
}
