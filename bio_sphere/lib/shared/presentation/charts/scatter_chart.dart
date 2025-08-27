// ADD THIS to: lib/chart/ui/chart_adapters.dart

import 'dart:math' as math;

import 'package:bio_sphere/models/widget_models/chart/chart_models.dart';
import 'package:bio_sphere/shared/presentation/charts/chart_axis.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Scatter chart widget built from ChartConfig.
class ScatterChartWidget extends StatelessWidget {
  final ChartConfig config;
  final List<Color> palette;
  final double pointRadius;

  const ScatterChartWidget({
    super.key,
    required this.config,
    required this.palette,
    this.pointRadius = 6.0,
  });

  List<ScatterSpot> _adaptToScatterSpots() {
    final spots = <ScatterSpot>[];

    for (int x = 0; x < config.buckets.length; x++) {
      final bucket = config.buckets[x];
      for (int s = 0; s < config.seriesNames.length; s++) {
        final series = config.seriesNames[s];
        final y = config.matrix[bucket]?[series] ?? 0.0;

        spots.add(
          ScatterSpot(
            x.toDouble(),
            y,
            dotPainter: FlDotCirclePainter(
              radius: 6.sp,
              color: palette[s % palette.length],
            ),
          ),
        );
      }
    }

    return spots;
  }

  @override
  Widget build(BuildContext context) {
    final spots = _adaptToScatterSpots();

    final maxY = config.maxY == 0 ? 1.0 : config.maxY;
    final maxX = math.max(0.0, config.buckets.length - 1.0);

    return ScatterChart(
      ScatterChartData(
        minX: -0.2,
        minY: 0,
        maxY: maxY,
        maxX: (maxX + 0.2),
        scatterSpots: spots,
        gridData: FlGridData(show: true),
        borderData: FlBorderData(show: false),
        titlesData: FlTitlesData(
          topTitles: ChartAxesBuilder.disableTitles(),
          leftTitles: ChartAxesBuilder.horizontalTile(config.units),
          rightTitles: ChartAxesBuilder.horizontalTile(config.units),
          bottomTitles: ChartAxesBuilder.bottomTitles(config.buckets),
        ),

        scatterTouchData: ScatterTouchData(enabled: false),
      ),
    );
  }
}
