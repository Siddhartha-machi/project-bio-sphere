import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'package:icons_plus/icons_plus.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:bio_sphere/shared/utils/style.dart';
import 'package:bio_sphere/shared/presentation/text/text_ui.dart';
import 'package:bio_sphere/shared/presentation/charts/bar_chart.dart';
import 'package:bio_sphere/shared/constants/widget/widget_enums.dart';
import 'package:bio_sphere/shared/presentation/charts/pie_chart.dart';
import 'package:bio_sphere/shared/presentation/charts/line_chart.dart';
import 'package:bio_sphere/shared/utils/chart/chart_transformers.dart';
import 'package:bio_sphere/models/widget_models/chart/chart_models.dart';
import 'package:bio_sphere/shared/presentation/charts/scatter_chart.dart';
import 'package:bio_sphere/shared/constants/widget/text_widget_enums.dart';
import 'package:bio_sphere/shared/presentation/buttons/generic_icon_button.dart';

class GenericChart extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool showLegend;
  final ChartUnits units;
  final ChartType chartType;
  final List<ChartData> rows;
  final ChartTransformOptions transformOptions;

  const GenericChart({
    super.key,
    required this.rows,
    required this.title,
    this.showLegend = true,
    required this.subtitle,
    required this.chartType,
    this.units = ChartUnits.none,
    this.transformOptions = const ChartTransformOptions(),
  });

  /// Compute ChartConfig once per build. This is pure and fast.
  ChartConfig _computeChartConfig() {
    return ChartTransformer.buildChartConfig(
      rows: rows,
      units: units,
      options: transformOptions,
    );
  }

  Widget _buildHeader(BuildContext context, ChartConfig cfg) {
    return Row(
      children: [
        Expanded(
          child: Column(
            spacing: 2.sp,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextUI(title),
              TextUI(subtitle, level: TextLevel.bodySmall),
            ],
          ),
        ),
        if (!cfg.isSingleSeries)
          GenericIconButton(
            onPressed: () {
              // Placeholder for expand/see more. Keep side-effect out of widget:
              // the parent should handle navigation or state changes.
            },
            iconSize: 14.sp,
            type: ButtonType.text,
            icon: FontAwesome.up_right_from_square_solid,
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final cfg = _computeChartConfig();
    final legendMap = ChartTransformer.buildLegendMap(cfg);
    final baseColor = Theme.of(context).colorScheme.primary;
    final paletteLen = math.max(cfg.seriesNames.length, cfg.buckets.length);
    final palette = Style.generateColorGradient(baseColor, paletteLen);

    // Choose chart widget
    Widget chartChild;

    switch (chartType) {
      case ChartType.bar:
        chartChild = BarChartWidget(config: cfg, palette: palette);
        break;
      case ChartType.line:
        chartChild = LineChartWidget(config: cfg, palette: palette);
        break;
      case ChartType.pie:
        chartChild = PieChartWidget(config: cfg, palette: palette);
        break;
      case ChartType.scatter:
        chartChild = ScatterChartWidget(config: cfg, palette: palette);
    }

    return Card(
      elevation: 8,
      child: Padding(
        padding: EdgeInsets.all(12.sp),
        child: Column(
          spacing: 25.sp,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context, cfg),

            ResponsiveChartContainer(child: chartChild),

            if (showLegend) ChartLegend(legendMap: legendMap, palette: palette),
          ],
        ),
      ),
    );
  }
}
