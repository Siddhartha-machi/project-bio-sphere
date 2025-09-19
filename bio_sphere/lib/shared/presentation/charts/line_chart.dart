import 'package:flutter/material.dart';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:bio_sphere/shared/utils/global.dart';
import 'package:bio_sphere/shared/presentation/charts/chart_axis.dart';
import 'package:bio_sphere/models/widget_models/chart/chart_models.dart';

/// Line chart widget built from ChartConfig.
class LineChartWidget extends StatelessWidget {
  final ChartConfig config;
  final List<Color> palette;

  const LineChartWidget({
    super.key,
    required this.config,
    required this.palette,
  });

  /// Convert ChartConfig -> list of LineChartBarData
  List<LineChartBarData> _adaptToLineBars() {
    return List.generate(config.seriesNames.length, (seriesIdx) {
      final series = config.seriesNames[seriesIdx];
      final spots = <FlSpot>[];

      for (int i = 0; i < config.buckets.length; i++) {
        final bucket = config.buckets[i];
        final value = config.matrix[bucket]?[series] ?? 0.0;
        spots.add(FlSpot(i.toDouble(), value));
      }

      return LineChartBarData(
        spots: spots,
        isCurved: true,
        barWidth: 3.sp,
        dotData: FlDotData(show: false),
        color: palette[seriesIdx % palette.length],
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final bars = _adaptToLineBars();

    return LineChart(
      LineChartData(
        lineBarsData: bars,
        maxY: config.maxY == 0 ? 1.0 : config.maxY,
        minY: 0.0,
        titlesData: FlTitlesData(
          topTitles: ChartAxesBuilder.disableTitles(),
          leftTitles: ChartAxesBuilder.horizontalTile(config.units),
          rightTitles: ChartAxesBuilder.horizontalTile(config.units),
          bottomTitles: ChartAxesBuilder.bottomTitles(config.buckets),
        ),
        borderData: FlBorderData(show: false),
        lineTouchData: LineTouchData(
          enabled: true,
          touchTooltipData: LineTouchTooltipData(
            getTooltipItems: (spots) {
              return spots.map((s) {
                final encodedValue = Global.formatters.number.condense(s.y);
                final seriesIndex = bars.indexWhere((b) => b.spots.contains(s));
                final seriesName = seriesIndex >= 0
                    ? config.seriesNames[seriesIndex]
                    : '';
                return LineTooltipItem(
                  '$seriesName: $encodedValue',
                  TextStyle(color: Colors.white, fontSize: 12.sp),
                );
              }).toList();
            },
          ),
        ),
      ),
    );
  }
}
