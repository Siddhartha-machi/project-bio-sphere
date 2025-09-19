import 'package:flutter/material.dart';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:bio_sphere/shared/utils/global.dart';
import 'package:bio_sphere/models/widget_models/chart/chart_models.dart';

/// Pie chart widget built from ChartConfig.
class PieChartWidget extends StatelessWidget {
  final ChartConfig config;
  final List<Color> palette;

  const PieChartWidget({
    super.key,
    required this.config,
    required this.palette,
  });

  List<PieChartSectionData> _buildSections() {
    final sections = <PieChartSectionData>[];
    final usedSeries = config.seriesNames.first;

    for (int index = 0; index < config.buckets.length; index++) {
      final bucket = config.buckets[index];
      final value = config.matrix[bucket]?[usedSeries] ?? 0.0;

      final encodedNum = Global.formatters.number.condense(value);

      sections.add(
        PieChartSectionData(
          value: value,
          title: encodedNum,
          color: palette[index % palette.length],
          titleStyle: TextStyle(color: Colors.white, fontSize: 13.sp),
        ),
      );
    }

    return sections;
  }

  @override
  Widget build(BuildContext context) {
    return PieChart(
      PieChartData(
        sectionsSpace: 4,
        sections: _buildSections(),
        pieTouchData: PieTouchData(enabled: true),
      ),
    );
  }
}
