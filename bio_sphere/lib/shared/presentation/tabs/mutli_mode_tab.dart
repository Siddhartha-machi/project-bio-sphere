import 'package:flutter/material.dart';

import 'package:bio_sphere/shared/utils/form/form_provider.dart';
import 'package:bio_sphere/shared/utils/form/form_state_manager.dart';
import 'package:bio_sphere/models/widget_models/generic_field_config.dart';

class MultiModeTab extends StatefulWidget {
  final FormStateManager formManager;
  final List<GenericFieldConfig> configList;

  const MultiModeTab({
    super.key,
    required this.configList,
    required this.formManager,
  });

  @override
  State<MultiModeTab> createState() => _MultiModeTabState();
}

class _MultiModeTabState extends State<MultiModeTab>
    with AutomaticKeepAliveClientMixin {
  late final Widget _child;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _child = _buildChild(); // Built only once
  }

  Widget _buildChild() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(12),
      child: FormProvider(
        useGrouping: true,
        configList: widget.configList,
        formManager: widget.formManager,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return _child;
  }
}
