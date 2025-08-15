import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:bio_sphere/shared/presentation/text/text_ui.dart';
import 'package:bio_sphere/shared/constants/widget/widget_enums.dart';
import 'package:bio_sphere/shared/presentation/tabs/mutli_mode_tab.dart';
import 'package:bio_sphere/models/widget_models/generic_field_config.dart';
import 'package:bio_sphere/shared/presentation/buttons/generic_button.dart';
import 'package:bio_sphere/shared/presentation/tabs/multi_mode_tab_controller.dart';

enum FormMode { view, edit, create }

class MultiModeTabForm extends StatefulWidget {
  final List<String> tabLabels;
  final List<List<GenericFieldConfig>> configs;

  const MultiModeTabForm({
    super.key,
    required this.configs,
    required this.tabLabels,
  }) : assert(tabLabels.length > 0),
       assert(tabLabels.length == configs.length);

  @override
  State<MultiModeTabForm> createState() => _MultiModeTabFormState();
}

class _MultiModeTabFormState extends State<MultiModeTabForm>
    with SingleTickerProviderStateMixin {
  /// State variables
  late int _tabsCount;
  late final TabController _tabController;
  late final MultiModeTabController _customController;

  @override
  void initState() {
    super.initState();

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

    /// Set up tabs controller
    _customController = MultiModeTabController(
      configs: widget.configs,
      tabController: _tabController,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();

    _customController.disposeManagers();

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

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GenericButton(
              isCircular: true,
              type: ButtonType.text,
              onPressed: _moveLeftHandler,
              prefixIcon: Icons.arrow_back,
            ),
            TextUI(widget.tabLabels[_tabController.index]),
            GenericButton(
              isCircular: true,
              type: ButtonType.text,
              onPressed: _moveRightHandler,
              prefixIcon: Icons.arrow_forward,
            ),
          ],
        ),

        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: List.generate(_tabsCount, (index) {
              return MultiModeTab(
                configList: widget.configs[index],
                formManager: _customController.getTabFormManager(index),
              );
            }),
          ),
        ),

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
              Expanded(
                child: GenericButton(
                  label: 'Submit',
                  onPressed: () {
                    _customController.validateAllTabs();
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
