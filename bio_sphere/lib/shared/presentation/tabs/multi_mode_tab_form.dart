import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:bio_sphere/shared/utils/form/form_provider.dart';
import 'package:bio_sphere/shared/presentation/text/text_ui.dart';
import 'package:bio_sphere/shared/constants/widget/widget_enums.dart';
import 'package:bio_sphere/shared/presentation/tabs/mutli_mode_tab.dart';
import 'package:bio_sphere/models/widget_models/generic_field_config.dart';
import 'package:bio_sphere/shared/presentation/buttons/generic_button.dart';
import 'package:bio_sphere/shared/presentation/buttons/generic_icon_button.dart';
import 'package:bio_sphere/shared/presentation/tabs/multi_mode_tab_controller.dart';
import 'package:bio_sphere/shared/presentation/forms/form_builders/view_mode_builder.dart';

class MultiModeTabForm extends StatefulWidget {
  final OpenMode openMode;
  final List<String> tabLabels;
  final Map<String, dynamic> data;
  final List<List<GenericFieldConfig>> configs;

  const MultiModeTabForm({
    super.key,
    this.data = const {},
    required this.configs,
    required this.tabLabels,
    this.openMode = OpenMode.view,
  }) : assert(tabLabels.length > 0),
       assert(tabLabels.length == configs.length);

  @override
  State<MultiModeTabForm> createState() => _MultiModeTabFormState();
}

class _MultiModeTabFormState extends State<MultiModeTabForm>
    with SingleTickerProviderStateMixin {
  /// State variables
  late int _tabsCount;
  late OpenMode _openMode;
  late final TabController _tabController;
  late MultiModeTabController? _customController;

  @override
  void initState() {
    super.initState();
    _openMode = widget.openMode;

    _tabsCount = widget.configs.length;

    /// Set up tab controller
    _tabController = TabController(length: _tabsCount, vsync: this);

    _tabController.addListener(() {
      if (_tabController.indexIsChanging ||
          _tabController.index != _tabController.previousIndex) {
        /// Force rebuild to update label
        setState(() {});
      }
    });

    if (_openMode == OpenMode.view) {
      _customController = null;
    } else {
      /// Register custom controller only in non-view mode
      _customController = MultiModeTabController(
        configs: widget.configs,
        initialValues: widget.data,
        tabController: _tabController,
      );
    }
  }

  @override
  void dispose() {
    /// DO NOT change the order
    _customController?.disposeManagers();

    _tabController.dispose();

    super.dispose();
  }

  VoidCallback? get _moveLeftHandler {
    if (_tabController.index == 0) return null;
    return () => _tabController.animateTo(_tabController.index - 1);
  }

  VoidCallback? get _moveRightHandler {
    if (_tabController.index == _tabsCount - 1) return null;
    return () => _tabController.animateTo(_tabController.index + 1);
  }

  void _changeFormMode() {
    setState(() {
      if (_openMode == OpenMode.view) {
        _openMode = OpenMode.editOrCreate;
        // Only create controller if not already created
        _customController ??= MultiModeTabController(
          configs: widget.configs,
          initialValues: widget.data,
          tabController: _tabController,
        );
      } else {
        _openMode = OpenMode.view;
        // Do NOT dispose or nullify _customController
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Top navigation row with left/right tab buttons and current tab label
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GenericIconButton(
              type: ButtonType.text,
              icon: Icons.arrow_back,
              onPressed: _moveLeftHandler,
            ),
            TextUI(widget.tabLabels[_tabController.index]),
            GenericIconButton(
              type: ButtonType.text,
              icon: Icons.arrow_forward,
              onPressed: _moveRightHandler,
            ),
          ],
        ),

        // Tab content area: shows either read-only or editable form depending on mode
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: List.generate(_tabsCount, (index) {
              if (_openMode == OpenMode.view) {
                // Read-only view mode
                return MultiModeTab(
                  key: ValueKey('view-mode-tab'),
                  builder: () => ReadOnlyForm(
                    data: widget.data,
                    configList: widget.configs[index],
                  ),
                );
              }

              // Edit/Create mode with form provider
              return MultiModeTab(
                key: ValueKey('edit-mode-tab'),
                builder: () => FormProvider(
                  useGrouping: true,
                  configList: widget.configs[index],
                  formManager: _customController!.getTabFormManager(index),
                ),
              );
            }),
          ),
        ),

        // Bottom action row: Cancel, Edit, or Submit buttons depending on mode
        Padding(
          padding: EdgeInsets.fromLTRB(12.sp, 8.sp, 12.sp, 30.sp),
          child: Row(
            spacing: 12.sp,
            children: [
              Expanded(
                child: GenericButton(
                  label: 'Cancel',
                  onPressed: () {},
                  type: ButtonType.outlined,
                ),
              ),
              if (_openMode == OpenMode.view)
                Expanded(
                  child: GenericButton(
                    label: 'Edit',
                    onPressed: _changeFormMode,
                  ),
                ),

              if (_openMode != OpenMode.view)
                Expanded(
                  child: GenericButton(
                    label: 'Submit',
                    onPressed: () {
                      _changeFormMode();
                      final result = _customController!.validateAllTabs();
                      if (result) {}
                    },
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
