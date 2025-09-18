import 'package:flutter/material.dart';

import 'package:icons_plus/icons_plus.dart';


import 'package:bio_sphere/shared/utils/form/form_provider.dart';
import 'package:bio_sphere/shared/constants/widget/widget_enums.dart';
import 'package:bio_sphere/shared/utils/form/form_state_manager.dart';
import 'package:bio_sphere/models/widget_models/generic_field_config.dart';
import 'package:bio_sphere/shared/presentation/ui_overlays/bottom_sheets.dart';
import 'package:bio_sphere/shared/presentation/buttons/generic_icon_button.dart';

class GenericFilters extends StatelessWidget {
  final List<GenericFieldConfig> filtersConfig;

  const GenericFilters(this.filtersConfig, {super.key});

  List<GenericFieldConfig> _buildSearchConfig() {
    return [
      GenericFieldConfig(
        name: 'search',
        hintText: 'Search',
        type: GenericFieldType.text,
      ),
    ];
  }

  Future<void> _showFilterBottomSheet(
    BuildContext ctx,
    FormStateManager formManager,
  ) async {
    final result = await BottomSheets.showBottomSheet(
      context: ctx,
      title: 'Filters',
      builder: (context) => Container(
        padding: EdgeInsets.all(12),
        child: FormProvider(
          formManager: formManager,
          configList: filtersConfig,
        ),
      ),
    );

    if (result != null) debugPrint(result);
  }

  @override
  Widget build(BuildContext context) {
    final searchFM = FormStateManager();
    final filtersFM = FormStateManager();

    return Row(
      children: [
        Expanded(
          child: FormProvider(
            formManager: searchFM,
            configList: _buildSearchConfig(),
          ),
        ),
        GenericIconButton(
          iconSize: 18,
          type: ButtonType.text,
          icon: FontAwesome.sliders_solid,
          variant: ButtonVariant.secondary,
          onPressed: () => _showFilterBottomSheet(context, filtersFM),
        ),
      ],
    );
  }
}
