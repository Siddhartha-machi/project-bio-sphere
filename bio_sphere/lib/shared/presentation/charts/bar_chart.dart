import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:bio_sphere/shared/presentation/text/text_ui.dart';
import 'package:bio_sphere/shared/utils/chart/chart_formatters.dart';
import 'package:bio_sphere/shared/presentation/charts/chart_axis.dart';
import 'package:bio_sphere/models/widget_models/chart/chart_models.dart';
import 'package:bio_sphere/shared/constants/widget/text_widget_enums.dart';

/// A responsive wrapper that centralizes chart sizing rules.
/// Makes sure charts have a reasonable height and respect parent width.
class ResponsiveChartContainer extends StatelessWidget {
  final Widget child;
  final double minHeight;
  final double maxHeightFractionOfScreen;

  const ResponsiveChartContainer({
    super.key,
    required this.child,
    this.minHeight = 220,
    this.maxHeightFractionOfScreen = 0.25,
  });

  @override
  Widget build(BuildContext context) {
    final maxH = MediaQuery.of(context).size.height * maxHeightFractionOfScreen;
    final height = math.max(minHeight, maxH);

    return SizedBox(width: double.infinity, height: height, child: child);
  }
}

/// Bar chart widget built from ChartConfig.
class BarChartWidget extends StatelessWidget {
  final double barWidth;
  final ChartConfig config;
  final List<Color> palette;

  const BarChartWidget({
    super.key,
    required this.config,
    this.barWidth = 14.0,
    required this.palette,
  });

  /// Convert ChartConfig -> list of BarChartGroupData
  List<BarChartGroupData> _adaptToBarGroups() {
    // Each bucket becomes a BarChartGroup with one rod per series
    final groups = <BarChartGroupData>[];

    for (int i = 0; i < config.buckets.length; i++) {
      final bucket = config.buckets[i];
      final seriesRods = <BarChartRodData>[];

      for (int j = 0; j < config.seriesNames.length; j++) {
        final series = config.seriesNames[j];
        final value = config.matrix[bucket]?[series] ?? 0.0;
        seriesRods.add(
          BarChartRodData(
            toY: value,
            width: barWidth,
            color: palette[j % palette.length],
            borderRadius: BorderRadius.zero,
          ),
        );
      }

      groups.add(
        BarChartGroupData(
          x: i,
          barRods: seriesRods,
          showingTooltipIndicators: [0],
        ),
      );
    }

    return groups;
  }

  @override
  Widget build(BuildContext context) {
    return BarChart(
      BarChartData(
        barGroups: _adaptToBarGroups(),
        maxY: config.maxY == 0 ? 1.0 : config.maxY,
        titlesData: FlTitlesData(
          topTitles: ChartAxesBuilder.disableTitles(),
          rightTitles: ChartAxesBuilder.disableTitles(),
          leftTitles: ChartAxesBuilder.horizontalTile(config.units),
          bottomTitles: ChartAxesBuilder.bottomTitles(config.buckets),
        ),

        borderData: FlBorderData(show: false),
        alignment: BarChartAlignment.spaceAround,
        barTouchData: BarTouchData(
          enabled: true,
          touchTooltipData: BarTouchTooltipData(
            tooltipMargin: 4.sp,
            tooltipPadding: EdgeInsets.zero,
            getTooltipColor: (group) => Colors.transparent,
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              /// Only show tooltips if we have a single series chart
              if (config.buckets.length > 1) return null;

              return BarTooltipItem(
                ChartUtils.formatValue(rod.toY, config.units),
                TextStyle(fontSize: 12.sp),
              );
            },
          ),
        ),
      ),
    );
  }
}

/// Compact legend widget: either horizontal chips or vertical list.
class ChartLegend extends StatelessWidget {
  final List<Color> palette;
  final Map<String, double> legendMap;

  const ChartLegend({
    super.key,
    required this.palette,
    required this.legendMap,
  });

  @override
  Widget build(BuildContext context) {
    final items = legendMap.keys.toList();

    return Center(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          spacing: 16.sp,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: _buildItems(items),
        ),
      ),
    );
  }

  List<Widget> _buildItems(List<String> items) {
    return List.generate(items.length, (i) {
      final k = items[i];
      final v = legendMap[k]!;
      final color = palette[i % palette.length];
      final valueText = v.isInfinite ? '' : ' ${v.toStringAsFixed(0)}';

      return Row(
        spacing: 6.sp,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(width: 12, height: 12, color: color),
          TextUI('$k $valueText', level: TextLevel.labelMedium),
        ],
      );
    });
  }
}
