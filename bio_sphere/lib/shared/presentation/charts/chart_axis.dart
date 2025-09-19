import 'package:flutter/material.dart';

import 'package:fl_chart/fl_chart.dart';

import 'package:bio_sphere/shared/presentation/text/text_ui.dart';
import 'package:bio_sphere/shared/utils/chart/chart_formatters.dart';
import 'package:bio_sphere/shared/constants/widget/widget_enums.dart';
import 'package:bio_sphere/shared/constants/widget/text_widget_enums.dart';

class ChartAxesBuilder {
  static AxisTitles bottomTitles(List<String> labels) {
    return AxisTitles(
      sideTitles: SideTitles(
        interval: 1.0,
        showTitles: true,
        getTitlesWidget: (index, meta) {
          /// When the interval is not even
          if (index != index.toInt()) return SizedBox.shrink();

          return SideTitleWidget(
            meta: meta,
            child: TextUI(labels[index.toInt()], level: TextLevel.labelSmall),
          );
        },
      ),
    );
  }

  static AxisTitles horizontalTile(ChartUnits units) {
    return AxisTitles(
      sideTitles: SideTitles(
        showTitles: true,
        reservedSize: 40,
        getTitlesWidget: (value, _) {
          return TextUI(
            level: TextLevel.labelSmall,
            ChartUtils.formatValue(value, units),
          );
        },
      ),
    );
  }

  static AxisTitles disableTitles() {
    return const AxisTitles(sideTitles: SideTitles(showTitles: false));
  }
}
